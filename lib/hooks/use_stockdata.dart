import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../types/data_container.dart';

DataContainer<List<StockdataDatapoint>> useStockdata(
    String symbol, StockdataInterval interval) {
  final state = useState<DataContainer<List<StockdataDatapoint>>>(
      DataContainer.waiting());
  useEffect(() {
    final sub = StockdataService.getInstance()
        .getStockdata(symbol, interval)
        .listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}