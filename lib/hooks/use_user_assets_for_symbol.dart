import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockinvestment_service.dart';
import 'package:neo/types/data_container.dart';
import 'package:neo/types/investment/investment_data.dart';

import '../service_locator.dart';
import '../services/stockdata_service.dart';

DataContainer<InvestmentData> useUserAssetsForSymbol(String symbol) {
  final DataService dataService = locator<DataService>();
  final state =
      useState<DataContainer<InvestmentData>>(DataContainer.waiting());
  useEffect(() {
    handleFetch() {
      StockInvestmentUtil()
          .getInvestmentDataForSymbol(
              symbol, state.value.data == null ? false : true)
          .then(
        (value) {
          state.value = DataContainer(data: value);
        },
      );
    }

    StockdataService.getInstance().addListener(handleFetch);
    dataService.addListener(handleFetch);
    handleFetch();
    return () {
      dataService.removeListener(handleFetch);
      StockdataService.getInstance().removeListener(handleFetch);
    };
  }, [symbol]);
  return state.value;
}
