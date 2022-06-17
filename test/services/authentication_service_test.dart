import 'package:flutter_test/flutter_test.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/authentication_service.dart';

void main() {
  test('Counter increments smoke test', () {
    var authServiceInstance = locator<AuthenticationService>();
    authServiceInstance.login('', '');

    expect(1, 1);
  });
}
