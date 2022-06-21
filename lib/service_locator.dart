import 'package:get_it/get_it.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/cognito_service.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<CognitoService>(CognitoService());
  locator.registerSingleton<AuthenticationService>(AuthenticationService());
}
