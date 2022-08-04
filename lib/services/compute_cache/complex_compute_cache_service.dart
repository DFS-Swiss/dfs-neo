import 'package:neo/enums/data_source.dart';
import 'package:neo/models/user_balance_datapoint.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/compute_cache/helper_complex_compute_cache_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/balance_history_container.dart';
import 'package:neo/types/price_development_datapoint.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:rxdart/subjects.dart';

class ComplexComputeCacheService {
  final BehaviorSubject<Map<String, Map<StockdataInterval, dynamic>>> cache =
      BehaviorSubject.seeded({});
  bool isInited = false;
  init() {
    DataService.getInstance()
        .getUserBalance(source: DataSource.cache)
        .skip(1)
        .listen((value) {
      computeData();
    });
    DataService.getInstance()
        .getUserAssetsHistory(source: DataSource.cache)
        .skip(1)
        .listen((value) {
      computeData();
    });
    StockdataService.getInstance().addListener(computeData);
  }

  computeData() async {
    _getPortfolioValueHistory(StockdataInterval.twentyFourHours);
  }

  Stream<BalanceHistoryContainer> readPortfolioValueHistroyFromCache(
      StockdataInterval interval) async* {
    if (cache.value["portfolioValueHistory"] != null &&
        cache.value["portfolioValueHistory"]![interval] != null) {
      yield cache.value["portfolioValueHistory"]![interval]
          as BalanceHistoryContainer;
    } else {
      yield await _getPortfolioValueHistory(interval);
    }
    yield* cache.map<BalanceHistoryContainer>((event) =>
        event["portfolioValueHistory"]![interval] as BalanceHistoryContainer);
  }

  writeToCache(String cacheKey, StockdataInterval interval, dynamic data) {
    if (!isInited) {
      init();
      isInited = true;
    }
    final tempCache = cache.value;
    if (cache.value[cacheKey] == null) {
      //There is no entry in the cache yet, a new map has to be created
      tempCache[cacheKey] = {interval: data};
    } else {
      //There is already an entry in the cache which can be overridden
      tempCache[cacheKey]![interval] = data;
    }
    cache.add(tempCache);
  }

  Future<BalanceHistoryContainer> _getPortfolioValueHistory(
    StockdataInterval interval,
  ) async {
    List<UserBalanceDatapoint> balance = await DataService.getInstance()
        .getUserBalanceHistory(source: DataSource.cache)
        .first;

    List<UserassetDatapoint> investments = await DataService.getInstance()
        .getUserAssetsHistory(source: DataSource.cache)
        .first;

    if (investments.isEmpty &&
        (balance.isEmpty ||
            (balance.length == 1 && balance[0].reference == "initial"))) {
      BalanceHistoryContainer data = BalanceHistoryContainer(
        total: [PriceDevelopmentDatapoint.empty()],
        portfolioIsEmpty: true,
        hasNoInvestments: true,
        inAssets: [PriceDevelopmentDatapoint.empty()],
        inCash: 0,
        averagePL: 0,
      );
      writeToCache("portfolioValueHistory", interval, data);
      return data;
    }

    //Using Map since its the only reasonable way to have a collection with distinct values in dart. The value has no meaning.
    final Map<String, bool> relevantSymbols = {};
    for (var investment in investments) {
      relevantSymbols[investment.symbol] = true;
    }
    List<List<PriceDevelopmentDatapoint>> valueList = [];

    for (var relevantSymbol in relevantSymbols.entries) {
      valueList.add(
        await HelperComplexComputeCacheService.getValueHistoryForSymbolV2(
          relevantSymbol.key,
          interval,
          investments,
        ),
      );
    }

    if (valueList.isEmpty) {
      BalanceHistoryContainer data = BalanceHistoryContainer(
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
      writeToCache("portfolioValueHistory", interval, data);
      return data;
    }

    final assetsOnlyList = HelperComplexComputeCacheService.mergeLists(
      0,
      List.filled(
        valueList[0].length,
        PriceDevelopmentDatapoint.empty(),
      ),
      valueList,
    );
    final balanceList = HelperComplexComputeCacheService.mapBalanceToHistory(
        balance, valueList[0]);
    valueList.add(balanceList);
    final cumilatedList = HelperComplexComputeCacheService.mergeLists(
        0,
        List.filled(
          valueList[0].length,
          PriceDevelopmentDatapoint.empty(),
        ),
        valueList);

    final averagePL = await HelperComplexComputeCacheService
        .calculateAverageProfitLossForAllInvestments(investments);

    BalanceHistoryContainer data = BalanceHistoryContainer(
        total: cumilatedList,
        inAssets: assetsOnlyList,
        inCash: balance.first.newBalance,
        averagePL: averagePL);

    writeToCache("portfolioValueHistory", interval, data);
    return data;
  }
}
