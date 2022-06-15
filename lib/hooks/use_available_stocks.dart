import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/services/data_service.dart';


import '../types/data_container.dart';

DataContainer<List<StockdataDocument>> useAvailableStocks() {
  final state =
      useState<DataContainer<List<StockdataDocument>>>(DataContainer.waiting());
  useEffect(() {
    final sub = DataService.getInstance().getAvailableStocks().listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
