import 'package:get_it/get_it.dart';
import 'package:neo/services/analytics_service.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication/authentication_service.dart';
import 'package:neo/services/chart_scrubbing_manager.dart';
import 'package:neo/services/authentication/cognito_service.dart';
import 'package:neo/services/crashlytics_service.dart';
import 'package:neo/services/data/data_handler.dart';
import 'package:neo/services/data/data_service.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest/rest_service.dart';
import 'package:neo/services/settings_service.dart';
import 'package:neo/services/stockdata/stockdata_service.dart';
import 'package:neo/services/websocket/websocket_service.dart';
import 'package:neo/services/stockdata/stockdata_handler.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<PublisherService>(PublisherService());
  locator.registerSingleton<StockdataHandler>(StockdataHandler());
  locator.registerSingleton<CrashlyticsService>(CrashlyticsService());
  locator.registerSingleton<SettingsService>(SettingsService());
  locator.registerSingleton<CognitoService>(CognitoService());
  locator.registerSingleton<AppStateService>(AppStateService());
  locator.registerSingleton<DataHandler>(DataHandler());
  locator.registerSingleton<AuthenticationService>(AuthenticationService());
  locator.registerSingleton<RESTService>(RESTService());
  locator.registerSingleton<StockdataService>(StockdataService());
  locator.registerSingleton<DataService>(DataService());
  locator.registerSingleton<ChartSrubbingManager>(ChartSrubbingManager());
  locator.registerSingleton<AnalyticsService>(AnalyticsService());
  locator.registerSingleton<WebsocketService>(WebsocketService());
}
