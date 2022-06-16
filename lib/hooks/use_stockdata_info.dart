import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/services/data_service.dart';
import '../types/data_container.dart';

DataContainer<StockdataDocument> useSymbolInfo(String symbol) {
  final state =
      useState<DataContainer<StockdataDocument>>(DataContainer.waiting());
  useEffect(() {
    final sub = DataService.getInstance().getStockInfo(symbol).listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
