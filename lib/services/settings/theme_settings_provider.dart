import 'package:flutter/material.dart';
import 'package:neo/services/settings/settings_provider_abstract.dart';

import '../../enums/theme_state.dart';

const THEME_KEY = "theme";

class ThemeSettingsProvider extends SettingsProvider<ThemeState> {
  final void Function(String, String) writeToStorage;
  final String? Function(String) readFromStorage;
  final window = WidgetsBinding.instance.window;
  late ThemeState _themeState;
  ThemeState get themeState => _themeState;

  late Brightness _systemBrightness;
  Brightness get brightness => _systemBrightness;

  ThemeSettingsProvider(this.writeToStorage, this.readFromStorage)
      : super(ThemeStateUtils.deserialize(readFromStorage(THEME_KEY))) {
    // This callback is called every time the brightness changes.x
    window.onPlatformBrightnessChanged = setPlatformBrightness;
    getThemePreference();
  }

  @override
  getValue() {
    return _themeState;
  }

  @override
  setValue(value) {
    _themeState = value;
    writeToStorage(THEME_KEY, value.serialize());
    getThemePreference();
  }

  getThemePreference() {
    if (readFromStorage(THEME_KEY) != null) {
      _themeState = ThemeStateUtils.deserialize(readFromStorage(THEME_KEY)!);
    } else {
      _themeState = ThemeState.system;
    }
    if (_themeState == ThemeState.system) {
      _systemBrightness = window.platformBrightness;
    } else {
      _systemBrightness =
          _themeState == ThemeState.light ? Brightness.light : Brightness.dark;
    }
    notifyListeners();
  }

  void setPlatformBrightness() {
    writeToStorage(THEME_KEY, themeState.serialize());
    getThemePreference();
  }
}
