import 'package:mockito/annotations.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/analytics_service.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication/authentication_service.dart';
import 'package:neo/services/authentication/cognito_service.dart';
import 'package:neo/services/crashlytics_service.dart';
import 'package:neo/services/rest/dio_handler.dart';
import 'package:neo/services/stockdata/stockdata_service.dart';
import 'package:neo/services/data/data_handler.dart';
import 'package:neo/services/data/data_service.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest/rest_service.dart';
import 'package:neo/services/websocket/websocket_service.dart';
import 'package:neo/services/stockdata/stockdata_handler.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<AuthenticationService>(),
  MockSpec<WebsocketService>(),
  MockSpec<DataHandler>(),
  MockSpec<PublisherService>(),
  MockSpec<StockdataHandler>(),
  MockSpec<RESTService>(),
  MockSpec<DataService>(),
  MockSpec<StockdataService>(),
  MockSpec<AnalyticsService>(),
  MockSpec<CognitoService>(),
  MockSpec<AppStateService>(),
  MockSpec<CrashlyticsService>(),
  MockSpec<DioHandler>()
])

MockAuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

MockDioHandler getAndRegisterDioHandler() {
  _removeRegistrationIfExists<DioHandler>();
  final service = MockDioHandler();
  locator.registerSingleton<DioHandler>(service);
  return service;
}

MockStockdataService getAndRegisterStockdataService() {
  _removeRegistrationIfExists<StockdataService>();
  final service = MockStockdataService();
  locator.registerSingleton<StockdataService>(service);
  return service;
}

MockCognitoService getAndRegisterCognitoService() {
  _removeRegistrationIfExists<CognitoService>();
  final service = MockCognitoService();
  locator.registerSingleton<CognitoService>(service);
  return service;
}

MockStockdataHandler getAndRegisterStockdataHandler() {
  _removeRegistrationIfExists<StockdataHandler>();
  final service = MockStockdataHandler();
  locator.registerSingleton<StockdataHandler>(service);
  return service;
}

MockWebsocketService getAndRegisterWebsocketService() {
  _removeRegistrationIfExists<WebsocketService>();
  final service = MockWebsocketService();
  locator.registerSingleton<WebsocketService>(service);
  return service;
}

MockDataHandler getAndRegisterDataHandlerService() {
  _removeRegistrationIfExists<DataHandler>();
  final service = MockDataHandler();
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
  getAndRegisterStockdataHandler();
  getAndRegisterStockdataService();
  getAndRegisterDioHandler();
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
  _removeRegistrationIfExists<StockdataHandler>();
  _removeRegistrationIfExists<DioHandler>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
