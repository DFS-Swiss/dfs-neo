import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/stockdata_service.dart';

import '../types/data_container.dart';

DataContainer<double> useLatestAssetPrice(String symbol) {
  final StockdataService stockdataService = locator<StockdataService>();
  final state = useState<DataContainer<double>>(DataContainer.waiting());
  useEffect(() {
    final sub =
        stockdataService.getLatestPrice(symbol).listen((event) {
      state.value = DataContainer(data: event.price);
    });
    return sub.cancel;
  }, [symbol]);
  return state.value;
}
