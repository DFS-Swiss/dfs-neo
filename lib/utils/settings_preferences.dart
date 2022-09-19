import 'package:neo/enums/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPreferences {
  static const THEME_KEY = "theme";
  static const HIDE_BALANCE_KEY = "hide_balance";

  setTheme(ThemeState value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(THEME_KEY, value.toString());
  }

  Future<ThemeState> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeString = sharedPreferences.getString(THEME_KEY);
    if (themeString == null) {
      return ThemeState.system;
    }

    return ThemeState.values.firstWhere((e) => e.toString() == themeString);
  }

  setHideBalance(bool hide) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(HIDE_BALANCE_KEY, hide);
  }

  Future<bool> getHideBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(HIDE_BALANCE_KEY) ?? false;
  }
}
