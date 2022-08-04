import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/compute_cache/complex_compute_cache_service.dart';
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

  useEffect(() {
    final sub = locator<ComplexComputeCacheService>()
        .readPortfolioValueHistroyFromCache(interval)
        .listen((event) {
      state.value = DataContainer(data: event);
    });
    return () {
      sub.cancel();
    };
  }, [interval]);
  return state.value;
}
