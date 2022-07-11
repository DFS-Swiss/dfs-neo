import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/stockdata_service.dart';

import '../types/data_container.dart';

DataContainer<double> useLatestAssetPrice(
    String symbol) {
  final state = useState<DataContainer<double>>(
      DataContainer.waiting());
  useEffect(() {
    final sub = StockdataService.getInstance()
        .getLatestPrice(symbol)
        .listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  });
  return state.value;
}
