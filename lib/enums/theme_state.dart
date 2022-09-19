import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ThemeState { light, dark, system }

extension ThemeStateUtils on ThemeState {
  static deserialize(String? v) {
    if (v == null) {
      return null;
    }
    switch (v) {
      case "light":
        return ThemeState.light;
      case "ThemeState.light":
        return ThemeState.light;
      case "dark":
        return ThemeState.dark;
      case "ThemeState.dark":
        return ThemeState.dark;
      case "system":
        return ThemeState.system;
      case "ThemeState.system":
        return ThemeState.system;
    }
  }

  String serialize() {
    switch (this) {
      case ThemeState.light:
        return "light";
      case ThemeState.dark:
        return "dark";
      case ThemeState.system:
        return "system";
    }
  }

  String toLocalString(BuildContext context) {
    switch (this) {
      case ThemeState.light:
        return AppLocalizations.of(context)!.settings_theme_light;
      case ThemeState.dark:
        return AppLocalizations.of(context)!.settings_theme_dark;
      case ThemeState.system:
        return AppLocalizations.of(context)!.settings_theme_system;
    }
  }
}
