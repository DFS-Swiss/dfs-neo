import 'package:flutter/foundation.dart';

class GlobalSettingsService extends ChangeNotifier {
  static GlobalSettingsService? _instance;
  static GlobalSettingsService getInstance() {
    return _instance ??= GlobalSettingsService._();
  }

  GlobalSettingsService._();

  bool _hideBalance = false;

  set hideBalance(bool v) {
    _hideBalance = v;
    notifyListeners();
  }

  bool get hideBalance {
    return _hideBalance;
  }
}
