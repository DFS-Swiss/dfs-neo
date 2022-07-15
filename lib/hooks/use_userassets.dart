import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import '../models/userasset_datapoint.dart';
import '../types/data_container.dart';

DataContainer<List<UserassetDatapoint>> useUserassets() {
  final cached = DataService.getInstance()
      .getDataFromCacheIfAvaliable<List<UserassetDatapoint>>("investments");
  final state = useState<DataContainer<List<UserassetDatapoint>>>(
      cached != null ? DataContainer(data: cached) : DataContainer.waiting());
  useEffect(() {
    final sub = DataService.getInstance().getUserAssets().listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
