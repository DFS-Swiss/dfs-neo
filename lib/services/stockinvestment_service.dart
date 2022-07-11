import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/investment/investment_data.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

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
    ];*/

class StockInvestmentUtil {
  StockInvestmentUtil();

  Future<InvestmentData> getInvestmentDataForSymbol(String symbol) async {
    final stockData = await StockdataService.getInstance()
        .getStockdata(symbol, StockdataInterval.oneYear)
        .first;
    try {
      final investments =
          await DataService.getInstance().getUserAssetsForSymbol(symbol).first;
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

      double totalTokenAmount = 0;
      double totalValue = 0;
      for (var element in investments) {
        totalValue += element.currentValue * element.tokenAmmount;
        totalTokenAmount += element.tokenAmmount;
      }

      double todayIncreas = calculateDailyIncrease(stockData, investments);
      double performance = calculatePerformance(stockData, investments);

      return InvestmentData(
          todayIncrease: 0,
          todayIncreasePercentage: 0,
          performance: 0,
          performancePercentage: 0,
          buyIn: totalValue / totalTokenAmount,
          quantity: totalTokenAmount,
          value: totalValue);
    } catch (e) {
      return InvestmentData(
          todayIncrease: 0,
          todayIncreasePercentage: 0,
          performance: 0,
          performancePercentage: 0,
          buyIn: 0,
          quantity: 0,
          hasNoInvestments: true,
          value: 0);
    }
  }

  double calculatePerformance(List<StockdataDatapoint> stockData,
      List<UserassetDatapoint> investments) {
    double performance = 0.0;
    for (var element in investments) {
      element.tokenAmmount *
          stockData.firstWhere((data) => data.time == element.time).price;
    }
    return performance;
  }

  double calculateDailyIncrease(List<StockdataDatapoint> stockData,
      List<UserassetDatapoint> investments) {
    double dailyIncrease = 0.0;

    return dailyIncrease;
  }

  double calculateBuyIn(List<StockdataDatapoint> stockData,
      List<UserassetDatapoint> investments) {
    double buyIn = 0.0;
    double totalTokenAmount = 0;
    for (var element in investments) {
      buyIn += element.currentValue * element.tokenAmmount;
      totalTokenAmount += element.tokenAmmount;
    }
    return buyIn / totalTokenAmount;
  }
}
