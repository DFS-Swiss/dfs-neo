import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../types/chart_scrubbing_state.dart';

class ChartSrubbingManager extends ChangeNotifier {
  ChartScrubbingState currentState = ChartScrubbingState(false, 0, 0);

  setState(ChartScrubbingState state) {
    currentState = state;
    notifyListeners();
  }
}
