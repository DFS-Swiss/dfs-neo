import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data/data_service.dart';
import 'package:neo/services/portfoliovalue_service.dart';
import 'package:neo/services/stockdata/stockdata_service.dart';
import 'package:neo/types/investment/investment_data.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../service_locator.dart';

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
  final DataService _dataService = locator<DataService>();
  final StockdataService _stockdataService = locator<StockdataService>();

  StockInvestmentUtil();

  Future<InvestmentData> getInvestmentDataForSymbol(
      String symbol, bool refetch) async {
    final stockData = await _stockdataService
        .getStockdata(symbol, StockdataInterval.oneYear)
        .first;

    final latestPrice = await _stockdataService.getLatestPrice(symbol).first;
    try {
      final investments = (await _dataService.getUserAssetsHistory().first)
          .where((element) => element.symbol == symbol)
          .toList();
      if (stockData.isEmpty || investments.isEmpty) {
        return InvestmentData(
          todayIncrease: 0,
          todayIncreasePercentage: 0,
          performance: 0,
          performancePercentage: 0,
          buyIn: 0,
          quantity: 0,
          value: 0,
        );
      }

      double totalTokenAmount = 0;
      double totalValue = 0;
      for (var element in investments) {
        if (element.difference > 0) {
          totalValue += element.currentValue * element.difference;
          totalTokenAmount += element.difference;
        }
      }

      final performance = _calculateStockPerformance(investments, latestPrice);
      final todayChange = (await PortfolioValueUtil().getAssetDevelopment(
        StockdataInterval.twentyFourHours,
        symbol,
        refetch,
      ));
      /*await _calculateAverageProfitLossForAllInvestments(investments
              .where((element) => element.time.isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day)))
              .toList());*/

      final out = InvestmentData(
        todayIncrease:
            todayChange.absoluteChange * investments.first.tokenAmmount,
        todayIncreasePercentage: todayChange.differenceInPercent,
        performance: performance[0],
        performancePercentage: performance[1],
        buyIn: totalValue / totalTokenAmount,
        quantity: investments.first.tokenAmmount,
        value: latestPrice.price * investments.first.tokenAmmount,
      );
      return out;
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

  List<double> _calculateStockPerformance(
      List<UserassetDatapoint> investments, StockdataDatapoint lastetPrice) {
    final totalAmountSpend = investments.fold<double>(
        0,
        (previousValue, element) =>
            previousValue += element.currentValue * element.difference);
    final currentValue = investments.first.tokenAmmount * lastetPrice.price;

    final absoluteChange = currentValue - totalAmountSpend;
    final percentChange = absoluteChange / totalAmountSpend;
    return [absoluteChange, percentChange * 100];
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
