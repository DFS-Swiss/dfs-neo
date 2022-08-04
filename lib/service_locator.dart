import 'package:get_it/get_it.dart';
import 'package:neo/services/analytics_service.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/chart_scrubbing_manager.dart';
import 'package:neo/services/cognito_service.dart';
import 'package:neo/services/compute_cache/complex_compute_cache_service.dart';
import 'package:neo/services/crashlytics_service.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<AppStateService>(AppStateService());
  locator.registerSingleton<CognitoService>(CognitoService());
  locator.registerSingleton<AuthenticationService>(AuthenticationService());
  locator.registerSingleton<ChartSrubbingManager>(ChartSrubbingManager());
  locator.registerSingleton<AnalyticsService>(AnalyticsService());
  locator.registerSingleton<CrashlyticsService>(CrashlyticsService());
  locator.registerSingleton<ComplexComputeCacheService>(
      ComplexComputeCacheService());
}
