import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mockito/annotations.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/cognito_service.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CognitoService>(returnNullOnMissingStub: true),
  MockSpec<CognitoIdToken>(returnNullOnMissingStub: true),
])
CognitoService getAndRegisterCognitoService() {
  _removeRegistrationIfExists<CognitoService>();
  final service = MockCognitoService();
  locator.registerSingleton<CognitoService>(service);
  return service;
}

CognitoIdToken getAndRegisterCognitoIdToken() {
  _removeRegistrationIfExists<CognitoIdToken>();
  final service = MockCognitoIdToken();
  locator.registerSingleton<CognitoIdToken>(service);
  return service;
}

void registerServices() {
  getAndRegisterCognitoService();
  getAndRegisterCognitoIdToken();
}

void unregisterServices() {
  locator.unregister<CognitoService>();
  locator.unregister<CognitoIdToken>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
