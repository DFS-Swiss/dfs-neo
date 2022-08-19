import 'package:neo/enums/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPreferences {
  static const THEME_KEY = "theme";

  setTheme(ThemeState value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(THEME_KEY, value.toString());
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeString = sharedPreferences.getString(THEME_KEY);
    if (themeString == null) {
      return ThemeState.system;
    }

    return ThemeState.values.firstWhere((e) => e.toString() == themeString);
  }
}
