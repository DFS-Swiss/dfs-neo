import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:neo/services/authentication_service.dart';

AuthState useAuthState() {
  final state = useState(AuthenticationService.getInstance().authState);
  useEffect(() {
    listen() {
      state.value = AuthenticationService.getInstance().authState;
    }

    AuthenticationService.getInstance().addListener(listen);
    return () {
      AuthenticationService.getInstance().removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
