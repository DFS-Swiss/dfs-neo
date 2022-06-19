import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/cognito_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Authentication Service Test -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    test('getCurrrentApiKey_sessionNull_throwsException', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.isSessionPresent()).thenReturn(false);

      // act
      // assert
      expect(() async => await authServiceInstance.getCurrentApiKey(),
          throwsA("User not authenticated"));
    });

    test('getCurrrentApiKey_sessionCouldNotBeRestored_throwsException',
        () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.isSessionPresent()).thenReturn(true);
      when(cognitoService.isIdTokenExpired()).thenReturn(true);

      // act
      // assert
      expect(() async => await authServiceInstance.getCurrentApiKey(),
          throwsA("Could not reresh session; Missing user or session object"));
    });

    test('getCurrrentApiKey_sessionActive_returnsJwtToken', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.isSessionPresent()).thenReturn(true);
      when(cognitoService.isIdTokenExpired()).thenReturn(false);
      when(cognitoService.getIdJwtToken()).thenReturn("testToken");

      // act
      var apiKey = await authServiceInstance.getCurrentApiKey();

      // assert
      expect(apiKey, "testToken");
    });

    test('login_newPasswordRequired_correctStateSet', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.createAndAuthenticateUser("", ""))
          .thenThrow(CognitoUserNewPasswordRequiredException());

      // act
      await authServiceInstance.login("", "");

      // assert
      expect(authServiceInstance.authState, AuthState.newPasswordRequired);
    });

    test('login_confirmationNecessary_correctStateSet', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.createAndAuthenticateUser("", ""))
          .thenThrow(CognitoUserConfirmationNecessaryException());

      // act
      expect(
          () async => await authServiceInstance.login("", ""), throwsException);

      // assert
      expect(authServiceInstance.authState, AuthState.verifyAccount);
    });

    test('login_noExceptionThrown_loginSuccessful', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      SharedPreferences.setMockInitialValues({}); //set values here
      when(cognitoService.createAndAuthenticateUser("", "")).thenReturn(null);
      when(cognitoService.getRefreshToken()).thenReturn("refreshTokenTest");

      // act
      await authServiceInstance.login("testUser", "");

      // assert
      expect(authServiceInstance.authState, AuthState.signedIn);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("refresh_token"), "refreshTokenTest");
      expect(prefs.getString("user_name"), "testUser");
    });

    test('logOut_verifyLogoutSuccessful', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.logoutCurrentPoolUser()).thenReturn(null);

      // act
      await authServiceInstance.logOut();

      // assert
      expect(authServiceInstance.authState, AuthState.signedOut);
      verify(await cognitoService.logoutCurrentPoolUser()).called(1);
    });

    test(
        'completeForceChangePassword_stateNotPasswordRequired_PasswordRequiredNotSent',
        () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      authServiceInstance.authState = AuthState.signedIn;

      // act
      await authServiceInstance.completeForceChangePassword("test");

      // assert
      verifyNever(await cognitoService.sendNewPasswordRequired("test"));
    });

    test('completeForceChangePassword_stateCorrect_PasswordRequiredSent',
        () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      authServiceInstance.authState = AuthState.newPasswordRequired;
      when(cognitoService.isUserPresent()).thenReturn(true);

      // act
      await authServiceInstance.completeForceChangePassword("test");

      // assert
      verify(await cognitoService.sendNewPasswordRequired("test")).called(1);
      expect(authServiceInstance.authState, AuthState.signedOut);
    });
  });
}
