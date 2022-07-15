import 'package:get_it/get_it.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/cognito_service.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<AppStateService>(AppStateService());
  locator.registerSingleton<CognitoService>(CognitoService());
  locator.registerSingleton<AuthenticationService>(AuthenticationService());
}
