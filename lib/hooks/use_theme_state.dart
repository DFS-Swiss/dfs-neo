import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/theme_state.dart';
import 'package:neo/services/settings/settings_service.dart';
import '../service_locator.dart';

ThemeState useThemeState() {
  final SettingsService settingsService = locator<SettingsService>();
  final state = useState(settingsService.themeSettings.themeState);
  useEffect(() {
    listen() {
      state.value = settingsService.themeSettings.themeState;
    }

    settingsService.themeSettings.addListener(listen);
    return () {
      settingsService.themeSettings.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
