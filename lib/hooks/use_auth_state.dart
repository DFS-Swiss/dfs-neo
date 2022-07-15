import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/services/authentication_service.dart';

import '../service_locator.dart';
import '../services/app_state_service.dart';

AppState useAppState() {
  final AppStateService appStateService = locator<AppStateService>();
  final state = useState(appStateService.state);
  useEffect(() {
    listen() {
      state.value = appStateService.state;
    }

    appStateService.addListener(listen);
    return () {
      appStateService.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
