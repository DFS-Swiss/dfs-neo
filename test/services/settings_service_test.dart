import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo/enums/theme_state.dart';
import 'package:neo/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Service Test - Constructor', () {
    setUp(() {
      registerServices();
    });
    tearDown(() {
      unregisterServices();
    });

    test('constructor_handlersSetCorrectly', () async {
      // arrange
      var settingsService = SettingsService();
      SharedPreferences.setMockInitialValues({});

      // act
      await settingsService.getThemePreference();
      var themeState = settingsService.themeState;
      var systemBrightness = settingsService.brightness;

      // assert
      expect(themeState, ThemeState.system);
      expect(systemBrightness, Brightness.light);
    });
  });

  group('Settings Service Test - SetPlatformBrightness', () {
    setUp(() {
      registerServices();
    });
    tearDown(() {
      unregisterServices();
    });

    test('getThemePreference_lightTheme_systemBrightnessLight', () async {
      // arrange
      var settingsService = SettingsService();
      SharedPreferences.setMockInitialValues({"theme": "ThemeState.light"});

      // act
      await settingsService.getThemePreference();
      var themeState = settingsService.themeState;
      var systemBrightness = settingsService.brightness;

      // assert
      expect(themeState, ThemeState.light);
      expect(systemBrightness, Brightness.light);
    });

     test('getThemePreference_darkTheme_systemBrightnessLight', () async {
      // arrange
      var settingsService = SettingsService();
      SharedPreferences.setMockInitialValues({"theme": "ThemeState.dark"});

      // act
      await settingsService.getThemePreference();
      var themeState = settingsService.themeState;
      var systemBrightness = settingsService.brightness;

      // assert
      expect(themeState, ThemeState.dark);
      expect(systemBrightness, Brightness.dark);
    });
  });
}
