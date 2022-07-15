import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:neo/enums/app_state.dart';

class AppStateService extends ChangeNotifier {
  AppState _state = AppState.signedOut;

  AppState get state {
    return _state;
  }

  set state(AppState newState) {
    _state = newState;
    notifyListeners();
  }

  init() async {
    final firstRun = await IsFirstRun.isFirstRun();
    if (firstRun) {
      state = AppState.onboarding;
      notifyListeners();
    }
  }
}
