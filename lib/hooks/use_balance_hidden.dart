import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/global_settings_service.dart';

bool useBalanceHidden() {
  final state = useState(GlobalSettingsService.getInstance().hideBalance);
  useEffect(() {
    listen() {
      state.value = GlobalSettingsService.getInstance().hideBalance;
    }

    GlobalSettingsService.getInstance().addListener(listen);
    return () {
      GlobalSettingsService.getInstance().removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
