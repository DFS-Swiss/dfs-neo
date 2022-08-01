import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/data_container.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../services/portfoliovalue_service.dart';
import '../types/balance_history_container.dart';

DataContainer<BalanceHistoryContainer> useBalanceHistory(
    StockdataInterval interval) {
  final state =
      useState<DataContainer<BalanceHistoryContainer>>(DataContainer.waiting());
  handleFetch() {
    PortfolioValueUtil()
        .getPortfolioValueHistory(
            interval, state.value.data == null ? false : true)
        .then(
      (value) {
        state.value = DataContainer(data: value);
      },
    );
  }

  useEffect(() {
    StockdataService.getInstance().addListener(handleFetch);
    DataService.getInstance().addListener(handleFetch);
    handleFetch();
    return () {
      DataService.getInstance().removeListener(handleFetch);
      StockdataService.getInstance().removeListener(handleFetch);
      //future?.ignore();
    };
  }, [interval]);
  return state.value;
}
