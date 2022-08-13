import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/services/data_service.dart';
import '../service_locator.dart';
import '../types/data_container.dart';

final DataService dataService = locator<DataService>();

DataContainer<StockdataDocument> useSymbolInfo(String symbol) {
  final cached = dataService
      .getDataFromCacheIfAvaliable<StockdataDocument>("symbol/$symbol");
  final state = useState<DataContainer<StockdataDocument>>(
      cached != null ? DataContainer(data: cached) : DataContainer.waiting());
  useEffect(() {
    final sub = dataService.getStockInfo(symbol).listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
