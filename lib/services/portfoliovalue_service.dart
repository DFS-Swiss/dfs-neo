import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../models/user_balance_datapoint.dart';
import '../types/balance_history_container.dart';
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
    ];*/

class PortfolioValueUtil {
  PortfolioValueUtil();

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
    return await StockdataService.getInstance().getLatestPrice(symbol).first;
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

  Future<List<UserBalanceDatapoint>> _queryHistoricBalanceData() async {
    List<UserBalanceDatapoint> historicData =
        await DataService.getInstance().getUserBalanceHistory().first;
    return historicData;
  }

  Future<List<PriceDevelopmentDatapoint>> _getValueHistoryForSymbol(
      String symbol,
      StockdataInterval interval,
      List<UserassetDatapoint> investments) async {
    List<PriceDevelopmentDatapoint> output = [];
    //await Future.delayed(Duration(milliseconds: 500));

    List<StockdataDatapoint> historicData =
        await _queryHistoricStockData(symbol, interval);

    List<PriceDevelopmentDatapoint> singleHistory = historicData
        .map((e) => PriceDevelopmentDatapoint(time: e.time, price: e.price))
        .toList();

    singleHistory.sort(
      (a, b) => a.time.compareTo(b.time),
    );

    //Wir müssen jetzt die Datenpunkte in dem singleHistory Dokument entsprechend des hinterlegten Amounts in investments manipulieren
    investments.sort(
      (a, b) => a.time.millisecondsSinceEpoch
          .compareTo(b.time.millisecondsSinceEpoch),
    );

    for (var singleDP in singleHistory) {
      //wir Laufden jeden Datenpunkt durch und schauen, von welcher Manipulation er betroffen seien muss
      if (singleDP.time.millisecondsSinceEpoch <
          investments.first.time.millisecondsSinceEpoch) {
        if (investments.first.difference != investments.first.tokenAmmount) {
          //Der Nutzer hatte die Aktie schon besessen bevor das erste Investment-Dokument für diesen Zeitraum aufgezeichnet wurde. D.h. dass die Aktie gewichtet werden muss mit tokenAmount-Differenz zu der jeweilgien Zeit
          output.add(
            PriceDevelopmentDatapoint(
              time: singleDP.time,
              price: singleDP.price *
                  (investments.first.tokenAmmount -
                      investments.first.difference),
            ),
          );
        } else {
          //Der Nutzer hat die Aktie zu diesem Zeitpunkt nicht besessen, somit wird dieser Datenpunkt ignoriert
          output.add(
            PriceDevelopmentDatapoint(
              time: singleDP.time,
              price: 0,
            ),
          );
        }
      } else {
        if (investments.length > 1) {
          //Gibt es überhaupt noch ein neueres Invesment als das aktuelle?
          //Falls ja
          if (singleDP.time.millisecondsSinceEpoch <
              investments[1].time.millisecondsSinceEpoch) {
            //Wir sind jetzt zwischen dem ititalen Kauf und dem nächsten Investment Dokument angelangt
            //In dieser Zeitspanne gewichten wir alle Dokumente mit dem Amount des initialen Kaufs
            output.add(
              PriceDevelopmentDatapoint(
                time: singleDP.time,
                price: singleDP.price * (investments.first.tokenAmmount),
              ),
            );
          } else {
            //Wir sind jetzt an einem Zeitpunkt hinter dem ersten Investmentdokument des Zeitraums angekommen. Nun muss geprüft werden ob es ein neueres gibt

            if (investments.length == 1) {
              //Wenn es KEIN aktuelleres Investmentdokument gibt, bedeutet dass das der Nutzer die Aktie nicht weiter getradet hat und sie kann mit der Menge des letzten Dokumentes gewichtet werden
              output.add(
                PriceDevelopmentDatapoint(
                  time: singleDP.time,
                  price: singleDP.price * (investments.first.tokenAmmount),
                ),
              );
            } else if (investments.length > 1) {
              //Es gibt ein aktuelleres Datenelement, also muss das erste gelöscht werden und die aktuellen Datenpunkte mit dem Amount im "neuen ersten" Dokument gewichtet werden
              investments.removeAt(0);
              output.add(
                PriceDevelopmentDatapoint(
                  time: singleDP.time,
                  price: singleDP.price * (investments.first.tokenAmmount),
                ),
              );
            }
          }
        } else {
          //Falls nein bewerten wir jetzt alle restlichen Datenpunkte mit dem Amount des aktuellsten Investmentdokuments
          output.add(
            PriceDevelopmentDatapoint(
              time: singleDP.time,
              price: singleDP.price * (investments.first.tokenAmmount),
            ),
          );
        }
      }
    }
    print(output);
    return output;
  }
}
