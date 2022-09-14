import 'package:neo/services/data/data_service.dart';
import 'package:neo/services/stockdata/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../service_locator.dart';

class PrefetchingUtils {
  
  Future prepareApp() async {
    final dataService = locator<DataService>();
    final stockService = locator<StockdataService>();
    final avlbStocks = await dataService.getAvailableStocks().first;

    await Future.any([
      Future.wait([
        dataService.getUserData().first,
        dataService.getUserBalance().first,
        dataService.getUserAssets().first,
        dataService.getUserAssetsHistory().first,
        dataService.getUserBalanceHistory().first,
        ...avlbStocks.map((e) => stockService
            .getStockdata(e.symbol, StockdataInterval.twentyFourHours)
            .first)
      ]),
      Future.delayed(Duration(seconds: 5))
    ]);
  }
}
