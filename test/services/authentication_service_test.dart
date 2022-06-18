import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/cognito_service.dart';

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
      expect(await authServiceInstance.getCurrentApiKey(),
          throwsA("Could not reresh session; Missing user or session object"));
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
      expect(await authServiceInstance.getCurrentApiKey(),
          throwsA("User not authenticated"));
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
  });
}
