import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/user_balance_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/price_development_datapoint.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

class HelperComplexComputeCacheService {
  static Future<List<StockdataDatapoint>> queryHistoricStockData(
      String symbol, StockdataInterval interval) async {
    List<StockdataDatapoint> historicData = await StockdataService.getInstance()
        .getStockdata(symbol, interval)
        .first;
    return historicData;
  }

  static Future<List<PriceDevelopmentDatapoint>> getValueHistoryForSymbolV2(
    String symbol,
    StockdataInterval interval,
    List<UserassetDatapoint> investments,
  ) async {
    List<PriceDevelopmentDatapoint> out = [];
    List<StockdataDatapoint> historicData =
        await queryHistoricStockData(symbol, interval);

    for (var historicDataObj in historicData) {
      double stockAmmountForThatPoint;
      try {
        final investmentsBeforThatPoint = <UserassetDatapoint>[];

        for (var investment in investments) {
          final localTimeInvestment = investment.time.toLocal();
          final localTimeStockData = historicDataObj.time.toLocal();
          if (localTimeInvestment.isBefore(localTimeStockData)) {
            investmentsBeforThatPoint.add(investment);
          }
        }

        stockAmmountForThatPoint = investmentsBeforThatPoint
            .where(
              (element) => element.symbol == symbol,
            )
            .first
            .tokenAmmount;
      } catch (e) {
        stockAmmountForThatPoint = 0;
      }
      out.add(
        PriceDevelopmentDatapoint(
          price: historicDataObj.price * stockAmmountForThatPoint,
          time: historicDataObj.time,
        ),
      );
    }
    return out;
  }

  static Future<double> queryCurrentStockData(String symbol) async {
    return (await StockdataService.getInstance().getLatestPrice(symbol).first)
         .price;
  }

  static Future<double> calculateAverageProfitLossForAllInvestments(
      List<UserassetDatapoint> investments) async {
    Map<String, bool> distinctSymbols = {};
    for (var investment in investments) {
      distinctSymbols[investment.symbol] = true;
    }
    double total = 0;
    for (var distinctSymbol in distinctSymbols.entries) {
      final price = await queryCurrentStockData(distinctSymbol.key);
      total += calculateAverageProfitLoss(
        investments
            .where((element) => element.symbol == distinctSymbol.key)
            .toList(),
        price,
      );
    }
    return total / distinctSymbols.length;
  }

  static double calculateAverageProfitLoss(
      List<UserassetDatapoint> relevantInvestments, double currentPrice) {
    List<double> profitLoss = [];
    for (var investment in relevantInvestments) {
      profitLoss.add(investment.currentValue - currentPrice);
    }
    double total = 0;
    for (var pl in profitLoss) {
      total += pl;
    }
    return (total / profitLoss.length) / 100;
  }

  static List<PriceDevelopmentDatapoint> mergeLists(
      index,
      List<PriceDevelopmentDatapoint> currentList,
      List<List<PriceDevelopmentDatapoint>> totalList) {
    if (totalList.length - 1 < index) {
      return currentList;
    }
    for (var i = 0; i < currentList.length; i++) {
      final relevantList = totalList[index];
      currentList[i] = PriceDevelopmentDatapoint(
        price: currentList[i].price + relevantList[i].price,
        time: relevantList[i].time,
      );
    }
    return mergeLists(index + 1, currentList, totalList);
  }

  static List<PriceDevelopmentDatapoint> mapBalanceToHistory(
      List<UserBalanceDatapoint> balanceHistory,
      List<PriceDevelopmentDatapoint> templateList) {
    List<PriceDevelopmentDatapoint> out = [];
    //balanceHistory.sort((a, b) => b.time.compareTo(a.time));

    for (var templateObj in templateList) {
      final balancesBeforePoint = [];

      for (var balance in balanceHistory) {
        if (balance.time.toLocal().isBefore(templateObj.time.toLocal())) {
          balancesBeforePoint.add(balance);
        }
      }
      double balanceForThatPoint;
      if (balancesBeforePoint.isNotEmpty) {
        final elements = balanceHistory.where(
          (element) =>
              element.time.toLocal().isBefore(templateObj.time.toLocal()),
        );
        balanceForThatPoint = elements.first.newBalance;
      } else {
        balanceForThatPoint = 0;
      }

      out.add(PriceDevelopmentDatapoint(
          price: balanceForThatPoint, time: templateObj.time));
    }
    return out;
  }
}
