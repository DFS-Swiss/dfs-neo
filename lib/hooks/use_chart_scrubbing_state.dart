import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/chart_scrubbing_manager.dart';
import 'package:neo/types/chart_scrubbing_state.dart';

ChartScrubbingState useChartScrubbingState() {
  final state = useState<ChartScrubbingState>(
      locator<ChartSrubbingManager>().currentState);

  update() {
    state.value = locator<ChartSrubbingManager>().currentState;
  }

  useEffect(() {
    locator<ChartSrubbingManager>().addListener(update);
    return () {
      locator<ChartSrubbingManager>().removeListener(update);
    };
  });
  return state.value;
}
