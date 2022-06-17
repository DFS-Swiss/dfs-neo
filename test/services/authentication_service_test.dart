import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/services/authentication_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Authentication Service Test -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    test('getCurrrentApiKey_sessionNull_throwsException', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = getAndRegisterCognitoService();
      when(cognitoService.getSession()).thenReturn(null);

      // act
      // assert
      expect(await authServiceInstance.getCurrentApiKey(),
          throwsA("User not authenticated"));
    });

    test('getCurrrentApiKey_sessionCouldNotBeRestored_throwsException',
        () async {
      // To be tested
    });

    test('getCurrrentApiKey_sessionActive_returnsJwtToken', () async {
      // arrange
      var authServiceInstance = AuthenticationService();
      var cognitoService = getAndRegisterCognitoService();
      var mockIdToken = getAndRegisterCognitoIdToken();
      when(mockIdToken.getExpiration())
          .thenReturn(DateTime.now().microsecondsSinceEpoch - 100);
      when(mockIdToken.jwtToken).thenReturn("testToken");
      CognitoUserSession session =
          CognitoUserSession(mockIdToken, CognitoAccessToken("1234567890"));
      when(cognitoService.getSession()).thenReturn(session);

      // act
      var apiKey = await authServiceInstance.getCurrentApiKey();

      // assert
      expect(apiKey, "testToken");
    });
  });
}
