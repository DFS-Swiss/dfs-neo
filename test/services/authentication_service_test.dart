import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication/authentication_service.dart';
import 'package:neo/services/authentication/cognito_service.dart';
import 'package:neo/services/publisher_service.dart';
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
      when(cognitoService.isUserPresent()).thenReturn(false);

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
      var appStateService = locator<AppStateService>();
      var cognitoService = locator<CognitoService>();
      when(cognitoService.createAndAuthenticateUser("", ""))
          .thenThrow(CognitoUserNewPasswordRequiredException());
      when(appStateService.state).thenReturn(AppState.newPasswordRequired);

      // act
      await authServiceInstance.login("", "");

      // assert
      expect(appStateService.state, AppState.newPasswordRequired);
    });

    test('login_confirmationNecessary_correctStateSet', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      var appStateService = locator<AppStateService>();

      when(cognitoService.createAndAuthenticateUser("", ""))
          .thenThrow(CognitoUserConfirmationNecessaryException());
      when(appStateService.state).thenReturn(AppState.verifyAccount);

      // act
      expect(
          () async => await authServiceInstance.login("", ""), throwsException);

      // assert
      expect(appStateService.state, AppState.verifyAccount);
    });

    test('login_noExceptionThrown_loginSuccessful', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      var appStateService = locator<AppStateService>();

      SharedPreferences.setMockInitialValues({}); //set values here
      when(cognitoService.createAndAuthenticateUser("testUser", ""))
          .thenReturn(null);
      when(cognitoService.getRefreshToken()).thenReturn("refreshTokenTest");
      when(cognitoService.getAccesTokenJwtToken())
          .thenReturn("accesTokenJwtTokenTest");
      when(cognitoService.getIdJwtToken()).thenReturn("idJwtTokenTest");
      when(appStateService.state).thenReturn(AppState.signedIn);

      // act
      await authServiceInstance.login("testUser", "");

      // assert
      expect(appStateService.state, AppState.signedIn);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("refresh_token"), "refreshTokenTest");
      expect(prefs.getString("user_name"), "testUser");
    });

    test('logOut_verifyLogoutSuccessful', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      var appStateService = locator<AppStateService>();
      var publisherService = locator<PublisherService>();

      when(publisherService.addEvent(PublisherEvent.logout)).thenReturn(null);
      when(publisherService.close()).thenReturn(null);
      when(cognitoService.logoutCurrentPoolUser()).thenReturn(null);
      when(appStateService.state).thenReturn(AppState.signedOut);

      // act
      await authServiceInstance.logOut();

      // assert
      expect(appStateService.state, AppState.signedOut);
      verify(await cognitoService.logoutCurrentPoolUser()).called(1);
      verify(publisherService.addEvent(PublisherEvent.logout)).called(1);
    });

    test(
        'completeForceChangePassword_stateNotPasswordRequired_PasswordRequiredNotSent',
        () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = locator<CognitoService>();
      var appStateService = locator<AppStateService>();
      when(appStateService.state).thenReturn(AppState.signedOut);

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
      var appStateService = locator<AppStateService>();
      when(cognitoService.isUserPresent()).thenReturn(true);
      when(cognitoService.sendNewPasswordRequired("test")).thenReturn(true);
      when(appStateService.state).thenReturn(AppState.newPasswordRequired);

      // act
      await authServiceInstance.completeForceChangePassword("test");

      // assert
      verify(await cognitoService.sendNewPasswordRequired("test")).called(1);
    });
  });
}
