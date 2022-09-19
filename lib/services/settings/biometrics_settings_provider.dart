import 'package:neo/services/settings/settings_provider_abstract.dart';

const String BIOMETRICS_ENABLED = "wants_biometric_auth";

class BiometricsEnabledSettingsProvider extends SettingsProvider<bool> {
  final void Function(String, bool) writeToStorage;
  final bool? Function(String) readFromStorage;

  bool _enabled = true;

  BiometricsEnabledSettingsProvider(this.writeToStorage, this.readFromStorage)
      : super(readFromStorage(BIOMETRICS_ENABLED));

  @override
  bool getValue() {
    return _enabled;
  }

  @override
  setValue(value) {
    writeToStorage(BIOMETRICS_ENABLED, value);
    _enabled = value;
    notifyListeners();
  }
}
