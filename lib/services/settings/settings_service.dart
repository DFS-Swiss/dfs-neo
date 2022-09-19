import 'package:neo/services/settings/biometrics_settings_provider.dart';
import 'package:neo/services/settings/hide_balance_settings_provider.dart';
import 'package:neo/services/settings/theme_settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferences _preferences;

  late final ThemeSettingsProvider themeSettings;
  late final HideBalanceSettingsProvider hideBalanceSettings;
  late final BiometricsEnabledSettingsProvider biometricsEnabledSettings;

  SettingsService();

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
    biometricsEnabledSettings =
        BiometricsEnabledSettingsProvider(writeToStorage, readFromStorage);
    hideBalanceSettings = HideBalanceSettingsProvider();
    themeSettings = ThemeSettingsProvider(writeToStorage, readFromStorage);
  }

  void writeToStorage(String key, dynamic v) {
    if (v is String) {
      _preferences.setString(key, v);
    } else if (v is int) {
      _preferences.setInt(key, v);
    } else if (v is bool) {
      _preferences.setBool(key, v);
    } else {
      throw "Unsupported type";
    }
  }

  T? readFromStorage<T>(String key) {
    if (_preferences.get(key) != null) {
      return _preferences.get(key) as T;
    }
    return null;
  }
}
