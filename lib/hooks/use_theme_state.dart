import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/theme_state.dart';
import 'package:neo/services/settings_service.dart';
import '../service_locator.dart';

ThemeState useThemeState() {
  final SettingsService settingsService = locator<SettingsService>();
  final state = useState(settingsService.themeState);
  useEffect(() {
    listen() {
      state.value = settingsService.themeState;
    }

    settingsService.addListener(listen);
    return () {
      settingsService.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
