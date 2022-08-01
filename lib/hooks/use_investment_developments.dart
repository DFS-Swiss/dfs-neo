import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/types/asset_performance_container.dart';

import '../services/data_service.dart';
import '../services/portfoliovalue_service.dart';
import '../services/stockdata_service.dart';
import '../types/data_container.dart';
import '../types/stockdata_interval_enum.dart';

DataContainer<List<AssetPerformanceContainer>> useInvestmentDevelopments(
    StockdataInterval interval) {
  final state = useState<DataContainer<List<AssetPerformanceContainer>>>(
      DataContainer.waiting());
  useEffect(() {
    handleFetch() {
      PortfolioValueUtil()
          .getDevelopmentForSymbols(
        interval,
        state.value.data == null ? false : true,
      )
          .then(
        (value) {
          state.value = DataContainer(data: value);
        },
      ).catchError((e) {
        print(e);
      });
    }

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
