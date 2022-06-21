import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:neo/services/authentication_service.dart';

import '../service_locator.dart';

AuthState useAuthState() {
  final AuthenticationService authenticationService =
      locator<AuthenticationService>();
  final state = useState(authenticationService.authState);
  useEffect(() {
    listen() {
      state.value = authenticationService.authState;
    }

    authenticationService.addListener(listen);
    return () {
      authenticationService.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
