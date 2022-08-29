import 'package:mockito/annotations.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/analytics_service.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/cognito_service.dart';
import 'package:neo/services/crashlytics_service.dart';
import 'package:neo/utils/data_handler.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/services/websocket/websocket_service.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<AuthenticationService>(),
  MockSpec<WebsocketService>(),
  MockSpec<DataHandler>(),
  MockSpec<PublisherService>(),
  MockSpec<RESTService>(),
  MockSpec<DataService>(),
  MockSpec<AnalyticsService>(),
  MockSpec<CognitoService>(),
  MockSpec<AppStateService>(),
  MockSpec<CrashlyticsService>(),
])

MockAuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

MockCognitoService getAndRegisterCognitoService() {
  _removeRegistrationIfExists<CognitoService>();
  final service = MockCognitoService();
  locator.registerSingleton<CognitoService>(service);
  return service;
}

MockWebsocketService getAndRegisterWebsocketService() {
  _removeRegistrationIfExists<WebsocketService>();
  final service = MockWebsocketService();
  locator.registerSingleton<WebsocketService>(service);
  return service;
}

MockDataHandlerService getAndRegisterDataHandlerService() {
  _removeRegistrationIfExists<DataHandler>();
  final service = MockDataHandlerService();
  locator.registerSingleton<DataHandler>(service);
  return service;
}

MockPublisherService getAndRegisterPublisherService() {
  _removeRegistrationIfExists<PublisherService>();
  final service = MockPublisherService();
  locator.registerSingleton<PublisherService>(service);
  return service;
}

MockRESTService getAndRegisterRESTService() {
  _removeRegistrationIfExists<RESTService>();
  final service = MockRESTService();
  locator.registerSingleton<RESTService>(service);
  return service;
}

MockAnalyticsService getAndRegisterAnalyticsService() {
  _removeRegistrationIfExists<AnalyticsService>();
  final service = MockAnalyticsService();
  locator.registerSingleton<AnalyticsService>(service);
  return service;
}

MockAppStateService getAndRegisterAppStateService() {
  _removeRegistrationIfExists<AppStateService>();
  final service = MockAppStateService();
  service.state = AppState.newPasswordRequired;
  locator.registerSingleton<AppStateService>(service);
  return service;
}

MockCrashlyticsService getAndRegisterCrashlyticsService() {
  _removeRegistrationIfExists<CrashlyticsService>();
  final service = MockCrashlyticsService();
  locator.registerSingleton<CrashlyticsService>(service);
  return service;
}

MockDataService getAndRegisterDataService() {
  _removeRegistrationIfExists<DataService>();
  final service = MockDataService();
  locator.registerSingleton<DataService>(service);
  return service;
}

void registerServices() {
  getAndRegisterAuthenticationService();
  getAndRegisterCrashlyticsService();
  getAndRegisterAnalyticsService();
  getAndRegisterCognitoService();
  getAndRegisterAppStateService();
  getAndRegisterDataService();
  getAndRegisterRESTService();
  getAndRegisterPublisherService();
  getAndRegisterDataHandlerService();
  getAndRegisterWebsocketService();
}

void unregisterServices() {
  _removeRegistrationIfExists<CognitoService>();
  _removeRegistrationIfExists<AppStateService>();
  _removeRegistrationIfExists<DataService>();
  _removeRegistrationIfExists<RESTService>();
  _removeRegistrationIfExists<PublisherService>();
  _removeRegistrationIfExists<DataHandler>();
  _removeRegistrationIfExists<WebsocketService>();
  _removeRegistrationIfExists<AuthenticationService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
