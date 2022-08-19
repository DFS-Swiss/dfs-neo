import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ThemeState { light, dark, system }

extension ThemeStateToString on ThemeState {
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
