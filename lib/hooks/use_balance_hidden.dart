import 'package:flutter_hooks/flutter_hooks.dart';
import '../service_locator.dart';
import '../services/settings/settings_service.dart';

bool useBalanceHidden() {
  final state =
      useState(locator<SettingsService>().hideBalanceSettings.getValue());
  useEffect(() {
    listen() {
      state.value = locator<SettingsService>().hideBalanceSettings.getValue();
    }

    locator<SettingsService>().hideBalanceSettings.addListener(listen);
    return () {
      locator<SettingsService>().hideBalanceSettings.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
