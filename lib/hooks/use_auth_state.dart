import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:neo/services/authentication_service.dart';

import '../service_locator.dart';

AuthState useAuthState() {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final state = useState(_authenticationService.authState);
  useEffect(() {
    listen() {
      state.value = _authenticationService.authState;
    }

    _authenticationService.addListener(listen);
    return () {
      _authenticationService.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
