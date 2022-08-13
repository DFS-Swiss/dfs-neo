import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/data_container.dart';
import 'package:neo/types/portfolio_performance_container.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../service_locator.dart';
import '../services/portfoliovalue_service.dart';

final DataService dataService = locator<DataService>();

DataContainer<PortfolioPerformanceContainer> usePortfolioDevelopment(
    StockdataInterval interval) {
  final state = useState<DataContainer<PortfolioPerformanceContainer>>(
      DataContainer.waiting());
  handleFetch() {
    PortfolioValueUtil().getPortfolioPerformanceHistory(
      interval,
      state.value.data == null ? false : true,
    );
    PortfolioValueUtil()
        .getPortfolioPerformanceHistory(
            interval, state.value.data == null ? false : true)
        .then(
      (value) {
        state.value = DataContainer(data: value);
      },
    );
  }

  useEffect(() {
    StockdataService.getInstance().addListener(handleFetch);
    dataService.addListener(handleFetch);
    handleFetch();
    return () {
      dataService.removeListener(handleFetch);
      StockdataService.getInstance().removeListener(handleFetch);
      //future?.ignore();
    };
  }, [interval]);
  return state.value;
}
