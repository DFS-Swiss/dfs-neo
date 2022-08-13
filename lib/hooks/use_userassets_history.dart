import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import '../models/userasset_datapoint.dart';
import '../service_locator.dart';
import '../types/data_container.dart';

final DataService dataService = locator<DataService>();

DataContainer<List<UserassetDatapoint>> useUserassetsHistory() {
  final cached = dataService
      .getDataFromCacheIfAvaliable<List<UserassetDatapoint>>(
          "investments/history");
  final state = useState<DataContainer<List<UserassetDatapoint>>>(
      cached != null ? DataContainer(data: cached) : DataContainer.waiting());
  useEffect(() {
    final sub =
        dataService.getUserAssetsHistory().listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
