import 'package:neo/services/settings/settings_provider_abstract.dart';

class HideBalanceSettingsProvider extends SettingsProvider<bool> {
  bool _hide = false;

  HideBalanceSettingsProvider() : super(false);

  @override
  bool getValue() {
    return _hide;
  }

  @override
  setValue(value) {
    _hide = value;
    notifyListeners();
  }
}
