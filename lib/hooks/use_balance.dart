import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/user_balance_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/types/data_container.dart';

import '../service_locator.dart';

DataContainer<UserBalanceDatapoint> useBalance() {
  final DataService dataService = locator<DataService>();
  final cached = dataService
      .getDataFromCacheIfAvaliable<UserBalanceDatapoint>("balance");

  final state = useState<DataContainer<UserBalanceDatapoint>>(
      cached != null ? DataContainer(data: cached) : DataContainer.waiting());
  useEffect(() {
    final sub = dataService.getUserBalance().listen(
      (value) {
        state.value = DataContainer(data: value);
      },
    );
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
