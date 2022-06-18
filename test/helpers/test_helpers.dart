import 'package:mockito/annotations.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/cognito_service.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CognitoService>(returnNullOnMissingStub: true),
])
MockCognitoService getAndRegisterCognitoService() {
  _removeRegistrationIfExists<CognitoService>();
  final service = MockCognitoService();
  locator.registerSingleton<CognitoService>(service);
  return service;
}

void registerServices() {
  getAndRegisterCognitoService();
}

void unregisterServices() {
  locator.unregister<CognitoService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
