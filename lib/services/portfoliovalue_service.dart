import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../models/user_balance_datapoint.dart';
import '../types/asset_performance_container.dart';
import '../types/balance_history_container.dart';
import '../types/price_development_datapoint.dart';
import '../utils/get_stockvalue_at_time.dart';
import '../utils/interval_to_time.dart';
import '../utils/lists.dart';

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

class PortfolioValueUtil {
  PortfolioValueUtil();

  Future<List<AssetPerformanceContainer>> getDevelopmentForSymbols(
      StockdataInterval interval) async {
    final out = <AssetPerformanceContainer>[];
    final investments = await _queryCurrentInvestments();
    for (var element in investments) {
      out.add(await _getAssetDevelopment(interval, element.symbol));
    }
    return out;
  }

  Future<AssetPerformanceContainer> _getAssetDevelopment(
      StockdataInterval interval, String symbol) async {
    var investments = await _queryHistoricInvestmentData();
    investments = investments
        .where((element) => element.symbol == symbol)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    final startOfInterval = getStartOfInterval(interval);

    final investmentBeforeStartOfInterval = investments
        .where((element) =>
            element.time.millisecondsSinceEpoch <
            startOfInterval.millisecondsSinceEpoch)
        .last;

    final stockData = await _queryHistoricStockData(symbol, interval);
    final assetValueAtStartOfInterval =
        investmentBeforeStartOfInterval.tokenAmmount * stockData.first.price;

    final investmentsDuringInterval = investments.where((element) =>
        element.time.millisecondsSinceEpoch >
        startOfInterval.millisecondsSinceEpoch);

    final investedValueDuringInterval =
        investmentsDuringInterval.fold<double>(0, (previousValue, element) {
      if (element.difference > 0) {
        return previousValue +
            (getStockValueAtTime(stockData, element.time).price *
                element.difference);
      } else {
        return previousValue -
            (getStockValueAtTime(stockData, element.time).price *
                (element.difference * (-1)));
      }
    });

    final currentValue = investments.last.tokenAmmount * stockData.last.price;
    final earnedMoney =
        (assetValueAtStartOfInterval + investedValueDuringInterval) -
            currentValue;
    final differenceInPercent = (((currentValue /
                    (assetValueAtStartOfInterval +
                        investedValueDuringInterval)) -
                1) *
            (-1)) *
        100;
    return AssetPerformanceContainer(
      symbol: symbol,
      interval: interval,
      differenceInPercent: differenceInPercent,
      earnedMoney: earnedMoney,
    );
  }

  Future<BalanceHistoryContainer> getPortfolioValueHistory(
      StockdataInterval interval) async {
    final investments = await _queryHistoricInvestmentData();
    final balance = await _queryHistoricBalanceData();

    if (investments.isEmpty &&
        (balance.isEmpty ||
            (balance.length == 1 && balance[0].reference == "initial"))) {
      return BalanceHistoryContainer(
        total: [PriceDevelopmentDatapoint.empty()],
        portfolioIsEmpty: true,
        hasNoInvestments: true,
        inAssets: [PriceDevelopmentDatapoint.empty()],
        inCash: 0,
        averagePL: 0,
      );
    }

    //Using Map since its the only reasonable way to have a collection with distinct values in dart. The value has no meaning.
    final Map<String, bool> relevantSymbols = {};
    for (var investment in investments) {
      relevantSymbols[investment.symbol] = true;
    }
    List<List<PriceDevelopmentDatapoint>> valueList = [];
    for (var relevantSymbol in relevantSymbols.entries) {
      valueList.add(
        await _getValueHistoryForSymbolV2(
          relevantSymbol.key,
          interval,
          investments,
        ),
      );
    }

    if (valueList.isEmpty) {
      return BalanceHistoryContainer(
        total: [
          PriceDevelopmentDatapoint(
            price: balance.first.newBalance,
            time: DateTime.now(),
          )
        ],
        inAssets: [PriceDevelopmentDatapoint.empty()],
        averagePL: 0,
        inCash: balance.first.newBalance,
        hasNoInvestments: true,
      );
    }
    final assetsOnlyList = _mergeLists(
      0,
      List.filled(
        valueList[0].length,
        PriceDevelopmentDatapoint.empty(),
      ),
      valueList,
    );
    final balanceList = _mapBalanceToHistory(balance, valueList[0]);
    valueList.add(balanceList);
    final cumilatedList = _mergeLists(
        0,
        List.filled(
          valueList[0].length,
          PriceDevelopmentDatapoint.empty(),
        ),
        valueList);

    final averagePL =
        await _calculateAverageProfitLossForAllInvestments(investments);
    return BalanceHistoryContainer(
        total: cumilatedList,
        inAssets: assetsOnlyList,
        inCash: balance.last.newBalance,
        averagePL: averagePL);
  }

  Future<double> _calculateAverageProfitLossForAllInvestments(
      List<UserassetDatapoint> investments) async {
    Map<String, bool> distinctSymbols = {};
    for (var investment in investments) {
      distinctSymbols[investment.symbol] = true;
    }
    double total = 0;
    for (var distinctSymbol in distinctSymbols.entries) {
      final price = await _queryCurrentStockData(distinctSymbol.key);
      total += _calculateAverageProfitLoss(
        investments
            .where((element) => element.symbol == distinctSymbol.key)
            .toList(),
        price,
      );
    }
    return total / distinctSymbols.length;
  }

  double _calculateAverageProfitLoss(
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

  List<PriceDevelopmentDatapoint> _mapBalanceToHistory(
      List<UserBalanceDatapoint> balanceHistory,
      List<PriceDevelopmentDatapoint> templateList) {
    List<PriceDevelopmentDatapoint> out = [];
    balanceHistory.sort((a, b) => a.time.compareTo(b.time));
    for (var templateObj in templateList) {
      final balanceForThatPoint = balanceHistory
          .where(
            (element) =>
                element.time.millisecondsSinceEpoch <
                templateObj.time.millisecondsSinceEpoch,
          )
          .last
          .newBalance;
      out.add(PriceDevelopmentDatapoint(
          price: balanceForThatPoint, time: templateObj.time));
    }
    return out;
  }

  Future<List<PriceDevelopmentDatapoint>> _getValueHistoryForSymbolV2(
      String symbol,
      StockdataInterval interval,
      List<UserassetDatapoint> investments) async {
    List<PriceDevelopmentDatapoint> out = [];
    List<StockdataDatapoint> historicData =
        await _queryHistoricStockData(symbol, interval);
    for (var historicDataObj in historicData) {
      double stockAmmountForThatPoint;
      try {
        stockAmmountForThatPoint = investments
            .where(
              (element) => element.symbol == symbol,
            )
            .where(
              (element) =>
                  element.time.millisecondsSinceEpoch <
                  historicDataObj.time.millisecondsSinceEpoch,
            )
            .last
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

  List<PriceDevelopmentDatapoint> _mergeLists(
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
    return _mergeLists(index + 1, currentList, totalList);
  }

  Future<double> _queryCurrentStockData(String symbol) async {
    return (await StockdataService.getInstance().getLatestPrice(symbol).first)
        .price;
  }

  Future<List<StockdataDatapoint>> _queryHistoricStockData(
      String symbol, StockdataInterval interval) async {
    List<StockdataDatapoint> historicData = await StockdataService.getInstance()
        .getStockdata(symbol, interval)
        .first;
    return historicData;
  }

  Future<List<UserassetDatapoint>> _queryHistoricInvestmentData() async {
    List<UserassetDatapoint> historicData =
        await DataService.getInstance().getUserAssetsHistory().first;
    return historicData;
  }

  Future<List<UserassetDatapoint>> _queryCurrentInvestments() async {
    return DataService.getInstance().getUserAssets().first;
  }

  Future<List<UserBalanceDatapoint>> _queryHistoricBalanceData() async {
    List<UserBalanceDatapoint> historicData =
        await DataService.getInstance().getUserBalanceHistory().first;
    return historicData;
  }
}
