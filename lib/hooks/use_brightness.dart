import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/settings_service.dart';
import '../service_locator.dart';

Brightness useBrightness() {
  final SettingsService settingsService = locator<SettingsService>();
  final state = useState<Brightness>(settingsService.brightness);
  useEffect(() {
    listen() {
      state.value = settingsService.brightness;
    }

    settingsService.addListener(listen);
    return () {
      settingsService.removeListener(listen);
    };
  }, ["_"]);
  return state.value;
}
