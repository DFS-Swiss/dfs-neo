import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/services/data/data_service.dart';

import '../service_locator.dart';
import '../types/data_container.dart';

DataContainer<List<StockdataDocument>> useAvailableStocks() {
  final DataService dataService = locator<DataService>();
  final cached = dataService
      .getDataFromCacheIfAvaliable<List<StockdataDocument>>("symbols");

  final state = useState<DataContainer<List<StockdataDocument>>>(
      cached != null ? DataContainer(data: cached) : DataContainer.waiting());
  useEffect(() {
    final sub = dataService.getAvailableStocks().listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
