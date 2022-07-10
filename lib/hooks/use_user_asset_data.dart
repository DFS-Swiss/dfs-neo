import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/types/data_container.dart';

DataContainer<List<UserassetDatapoint>> useUserAssetData(String symbol) {
  final state = useState<DataContainer<List<UserassetDatapoint>>>(DataContainer.waiting());
  useEffect(() {
    final sub = DataService.getInstance().getUserAssetsForSymbol(symbol).listen((event) {
      state.value = DataContainer(data: event);
    }, onError: (e) {
      state.value = DataContainer(error: e);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
