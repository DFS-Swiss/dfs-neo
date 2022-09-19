import 'package:flutter_hooks/flutter_hooks.dart';
import '../service_locator.dart';
import '../services/settings/settings_service.dart';

bool useBalanceHidden() {
  final SettingsService settingsService = locator<SettingsService>();
  final state =
      useState(settingsService.hideBalanceSettings.getValue());
  useEffect(() {
    listen() {
      state.value = settingsService.hideBalanceSettings.getValue();
    }

    settingsService.hideBalanceSettings.addListener(listen);
    return () {
      settingsService.hideBalanceSettings.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
