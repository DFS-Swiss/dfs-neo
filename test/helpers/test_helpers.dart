import 'package:mockito/annotations.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/cognito_service.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CognitoService>(returnNullOnMissingStub: true),
  MockSpec<AppStateService>(),
])
MockCognitoService getAndRegisterCognitoService() {
  _removeRegistrationIfExists<CognitoService>();
  final service = MockCognitoService();
  locator.registerSingleton<CognitoService>(service);
  return service;
}

MockAppStateService getAndRegisterAppStateService() {
  _removeRegistrationIfExists<AppStateService>();
  final service = MockAppStateService();
  service.state = AppState.newPasswordRequired;
  locator.registerSingleton<AppStateService>(service);
  return service;
}

void registerServices() {
  getAndRegisterCognitoService();
  getAndRegisterAppStateService();
}

void unregisterServices() {
  locator.unregister<CognitoService>();
  locator.unregister<AppStateService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
