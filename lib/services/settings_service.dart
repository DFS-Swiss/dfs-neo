import 'package:flutter/material.dart';
import 'package:neo/enums/theme_state.dart';
import 'package:neo/utils/settings_preferences.dart';

class SettingsService extends ChangeNotifier {
  late ThemeState _themeState;
  late SettingPreferences _preferences;
  ThemeState get themeState => _themeState;
  final window = WidgetsBinding.instance.window;

  late Brightness _systemBrightness;
  Brightness get brightness => _systemBrightness;

  SettingsService() {
    // This callback is called every time the brightness changes.x
    window.onPlatformBrightnessChanged = setPlatformBrightness;
    _preferences = SettingPreferences();
    getThemePreference();
  }

  set themeState(ThemeState themeState) {
    _themeState = themeState;
    _preferences.setTheme(themeState);
    getThemePreference();
    notifyListeners();
  }

  getThemePreference() async {
    _themeState = await _preferences.getTheme();
    if (_themeState == ThemeState.system) {
      _systemBrightness = window.platformBrightness;
    } else {
      _systemBrightness = _themeState == ThemeState.light ? Brightness.light : Brightness.dark;
    }
    notifyListeners();
  }

  void setPlatformBrightness() {
    _preferences.setTheme(themeState);
    getThemePreference();
    notifyListeners();
  }
}
