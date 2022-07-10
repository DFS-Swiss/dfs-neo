import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/investment/investment_data.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../models/user_balance_datapoint.dart';
import '../types/price_development_datapoint.dart';

/*investments = [
      //Der Nutzer kauft zum aller ersten Mal 2 Apple Aktien
      UserassetDatapoint(
          tokenAmmount: 2.0,
          symbol: "dAAPL",
          currentPrice: 100,
          time: DateTime(2022, 6, 16, 0, 0),
          difference: 2.0),
      UserassetDatapoint(
          tokenAmmount: 1.0,
          symbol: "dAAPL",
          currentPrice: 100,
          time: DateTime(2022, 6, 16, 6, 0),
          difference: -1.0),
      //Der Nutzer kauft einen Tag später noch eine Apple Aktie
      UserassetDatapoint(
          tokenAmmount: 3.0,
          symbol: "dAAPL",
          currentPrice: 100,
          time: DateTime(2022, 6, 16, 12, 0),
          difference: 1.0),
    ];

class StockInvestmentUtil {
  StockInvestmentUtil();

  Future<InvestmentData> getInvestmentDataForSymbol(
      StockdataInterval interval, String symbol) async {
    final investments = await _queryUserInvestmentData(symbol);
    final stockData = await _queryHistoricStockData(symbol, interval);

    if (stockData.isEmpty || investments.isEmpty) {
      return InvestmentData(
          todayIncrease: 0,
          todayIncreasePercentage: 0,
          performance: 0,
          performancePercentage: 0,
          buyIn: 0,
          quantity: 0,
          value: 0);
    }

    double performance = calculatePerformance(stockData, investments);

    return InvestmentData(
        todayIncrease: 0,
        todayIncreasePercentage: 0,
        performance: 0,
        performancePercentage: 0,
        buyIn: 0,
        quantity: 0,
        value: 0);
  }
  
  double calculatePerformance(List<StockdataDatapoint> stockData, List<UserassetDatapoint> investments) {
    double performance = 0.0;
    investments.forEach((element) {
      element.tokenAmmount * stockData.firstWhere((data) => data.time == element.time).price;
    });
    return performance;
  }

  Future<List<UserassetDatapoint>> _queryHistoricInvestmentData() async {
    List<UserassetDatapoint> historicData =
        await DataService.getInstance().getUserAssetsHistory().first;
    return historicData;
  }

  Future<List<UserBalanceDatapoint>> _queryHistoricBalanceData() async {
    List<UserBalanceDatapoint> historicData =
        await DataService.getInstance().getUserBalanceHistory().first;
    return historicData;
  }
}
*/