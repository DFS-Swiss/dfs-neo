import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/stockdata_datapoint.dart';
import '../services/stockdata_service.dart';
import '../types/data_container.dart';

DataContainer<StockdataDatapoint> useLatestPrice(String symbol) {
  final state =
      useState<DataContainer<StockdataDatapoint>>(DataContainer.waiting());
  useEffect(() {
    final sub =
        StockdataService.getInstance().getLatestPrice(symbol).listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
