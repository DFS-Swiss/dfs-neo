import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/user_balance_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/types/data_container.dart';

DataContainer<UserBalanceDatapoint> useBalance() {
  final state =
      useState<DataContainer<UserBalanceDatapoint>>(DataContainer.waiting());
  useEffect(() {
    final sub = DataService.getInstance().getUserBalance().listen(
      (value) {
        state.value = DataContainer(data: value);
      },
    );
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
