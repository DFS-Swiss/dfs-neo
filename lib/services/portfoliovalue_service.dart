import 'package:neo/enums/data_source.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../models/user_balance_datapoint.dart';
import '../service_locator.dart';
import '../types/asset_performance_container.dart';
import '../types/balance_history_container.dart';
import '../types/portfolio_performance_container.dart';
import '../types/price_development_datapoint.dart';
import '../utils/interval_to_time.dart';

class PortfolioValueUtil {
  PortfolioValueUtil();
  final DataService _dataService = locator<DataService>();
  
  Future<PortfolioPerformanceContainer> getPortfolioPerformanceHistory(
      StockdataInterval interval, bool refetch) async {
    final portfolioValue = await getPortfolioValueHistory(interval, refetch);
    final balancesChanges = await _queryHistoricBalanceData(refetch);
    final stockdataTemplate = await _queryHistoricStockData("dAAPL", interval);
    

    final developmentGraph = <PriceDevelopmentDatapoint>[];
    for (var element in stockdataTemplate) {
      final data = _getPortfolioPerformanceForPoint(
        getStartOfInterval(interval),
        element.time,
        balancesChanges,
        portfolioValue,
      );
      developmentGraph
          .add(PriceDevelopmentDatapoint(price: data[1], time: element.time));
    }
    final overall = _getPortfolioPerformanceForPoint(
      getStartOfInterval(interval),
      DateTime.now(),
      balancesChanges,
      portfolioValue,
    );
    return PortfolioPerformanceContainer(
      absoluteChange: overall[0],
      perCentChange: overall[1],
      development: developmentGraph,
    );
  }

  List<double> _getPortfolioPerformanceForPoint(
    DateTime startOfInterval,
    DateTime endOfInterval,
    List<UserBalanceDatapoint> balancesChanges,
    BalanceHistoryContainer portfolioValue,
  ) {
    final relevantbalancesChangesInInterval = balancesChanges
        .where((element) =>
            element.time.isAfter(startOfInterval) &&
            element.time.isBefore(endOfInterval))
        .where((element) =>
            element.type == "debug_add" ||
            element.type == "deposit" ||
            element.type == "withdrawal")
        .toList();
    final externalisedFunds = relevantbalancesChangesInInterval.fold<double>(
      0,
      (previousValue, element) => previousValue + element.difference,
    );

    final cleanedBalanceChangeAbs =
        (portfolioValue.total.first.price - portfolioValue.total.last.price) -
            externalisedFunds;
    final changeInPerCent =
        cleanedBalanceChangeAbs / portfolioValue.total.last.price;
    return [cleanedBalanceChangeAbs, changeInPerCent * 100];
  }

  Future<List<AssetPerformanceContainer>> getDevelopmentForSymbols(
      StockdataInterval interval, bool refetch) async {
    final out = <AssetPerformanceContainer>[];
    final investments = await _queryCurrentInvestments(refetch);
    for (var element in investments) {
      out.add(await getAssetDevelopment(interval, element.symbol, refetch));
    }
    return out;
  }

  Future<AssetPerformanceContainer> getAssetDevelopment(
      StockdataInterval interval, String symbol, bool refetch) async {
    var investments = await _queryHistoricInvestmentData(refetch);
    investments = investments
        .where((element) => element.symbol == symbol)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    final stockData = await _queryHistoricStockData(symbol, interval);

    final stockPriceChange = ((stockData.first.price - stockData.last.price) /
            stockData.last.price) *
        100;

    final investValueChange = investments.last.tokenAmmount * stockPriceChange;

    return AssetPerformanceContainer(
      symbol: symbol,
      interval: interval,
      differenceInPercent: stockPriceChange,
      earnedMoney: investValueChange,
      absoluteChange: stockData.first.price - stockData.last.price,
    );
  }

  Future<BalanceHistoryContainer> getPortfolioValueHistory(
      StockdataInterval interval, bool refetch) async {
    final investments = await _queryHistoricInvestmentData(refetch);
    var balance = await _queryHistoricBalanceData(refetch);

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
        inCash: balance.first.newBalance,
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

  Future<List<PriceDevelopmentDatapoint>> _getValueHistoryForSymbolV2(
    String symbol,
    StockdataInterval interval,
    List<UserassetDatapoint> investments,
  ) async {
    List<PriceDevelopmentDatapoint> out = [];
    List<StockdataDatapoint> historicData =
        await _queryHistoricStockData(symbol, interval);

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

  Future<List<UserassetDatapoint>> _queryHistoricInvestmentData(
      bool refetch) async {
    List<UserassetDatapoint> historicData = await _dataService
        .getUserAssetsHistory(
            source: refetch ? DataSource.network : DataSource.cache)
        .first;
    return historicData;
  }

  Future<List<UserassetDatapoint>> _queryCurrentInvestments(
      bool refetch) async {
    return _dataService
        .getUserAssets(source: refetch ? DataSource.network : DataSource.cache)
        .first;
  }

  Future<List<UserBalanceDatapoint>> _queryHistoricBalanceData(
      bool refetch) async {
    List<UserBalanceDatapoint> historicData = await _dataService
        .getUserBalanceHistory(
            source: refetch ? DataSource.network : DataSource.cache)
        .first;
    return historicData;
  }
}
