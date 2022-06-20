import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/types/data_container.dart';
import 'package:neo/types/price_development_datapoint.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../services/portfoliovalue_service.dart';
import '../types/balance_history_container.dart';

DataContainer<BalanceHistoryContainer> useBalanceHistory(
    StockdataInterval interval) {
  final state =
      useState<DataContainer<BalanceHistoryContainer>>(DataContainer.waiting());
  useEffect(() {
    PortfolioValueUtil().getPortfolioValueHistory(interval).then(
      (value) {
        state.value = DataContainer(data: value);
      },
    );
    return;
  }, [interval]);
  return state.value;
}
