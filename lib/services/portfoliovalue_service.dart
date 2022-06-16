import 'package:fl_chart/fl_chart.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

class Portfoliovalue {
  List<StockdataDocument> relevantSymbols = [];
  Portfoliovalue() {}

  queryRelevantSymbols() async {
    await Future.delayed(Duration(milliseconds: 500));
    relevantSymbols = [
      StockdataDocument(
          symbol: "dAAPL", displayName: "Test", imageUrl: "", description: ""),
      StockdataDocument(
          symbol: "dGME", displayName: "", imageUrl: "", description: "")
    ];
  }

  Future<List<StockdataDatapoint>> queryHistoricStockData(
      String symbol, StockdataInterval interval) async {
    List<StockdataDatapoint> historicData = await StockdataService.getInstance()
        .getStockdata(symbol, interval)
        .first;
    return historicData;
  }

  Future<List<FlSpot>> queryInvestmentDocuments() async {
    List<UserassetDatapoint> investments = [];
    List<FlSpot> resultAAPL = [];
    //await Future.delayed(Duration(milliseconds: 500));
    investments = [
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

    List<StockdataDatapoint> historicData = await queryHistoricStockData(
        "dAAPL", StockdataInterval.twentyFourHours);

    List<FlSpot> singleHistory = historicData
        .map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
        .toList();

    singleHistory.sort(
      (a, b) => a.x.compareTo(b.x),
    );

    //Wir müssen jetzt die Datenpunkte in dem singleHistory Dokument entsprechend des hinterlegten Amounts in investments manipulieren
    investments.sort(
      (a, b) => a.time.millisecondsSinceEpoch
          .compareTo(b.time.millisecondsSinceEpoch),
    );

    for (var singleDP in singleHistory) {
      //wir Laufden jeden Datenpunkt durch und schauen, von welcher Manipulation er betroffen seien muss
      if (singleDP.x < investments.first.time.millisecondsSinceEpoch) {
        if (investments.first.difference != investments.first.tokenAmmount) {
          //Der Nutzer hatte die Aktie schon besessen bevor das erste Investment-Dokument für diesen Zeitraum aufgezeichnet wurde. D.h. dass die Aktie gewichtet werden muss mit tokenAmount-Differenz zu der jeweilgien Zeit
          resultAAPL.add(
            FlSpot(
              singleDP.x,
              singleDP.y *
                  (investments.first.tokenAmmount -
                      investments.first.difference),
            ),
          );
        } else {
          //Der Nutzer hat die Aktie zu diesem Zeitpunkt nicht besessen, somit wird dieser Datenpunkt ignoriert
          resultAAPL.add(
            FlSpot(
              singleDP.x,
              0,
            ),
          );
        }
      } else {
        if (investments.length > 1) {
          //Gibt es überhaupt noch ein neueres Invesment als das aktuelle?
          //Falls ja
          if (singleDP.x <
              investments.elementAt(1).time.millisecondsSinceEpoch) {
            //Wir sind jetzt zwischen dem ititalen Kauf und dem nächsten Investment Dokument angelangt
            //In dieser Zeitspanne gewichten wir alle Dokumente mit dem Amount des initialen Kaufs
            resultAAPL.add(
              FlSpot(
                singleDP.x,
                singleDP.y * (investments.first.tokenAmmount),
              ),
            );
          } else {
            //Wir sind jetzt an einem Zeitpunkt hinter dem ersten Investmentdokument des Zeitraums angekommen. Nun muss geprüft werden ob es ein neueres gibt

            if (investments.length == 1) {
              //Wenn es KEIN aktuelleres Investmentdokument gibt, bedeutet dass das der Nutzer die Aktie nicht weiter getradet hat und sie kann mit der Menge des letzten Dokumentes gewichtet werden
              resultAAPL.add(
                FlSpot(
                  singleDP.x,
                  singleDP.y * (investments.first.tokenAmmount),
                ),
              );
            } else if (investments.length > 1) {
              //Es gibt ein aktuelleres Datenelement, also muss das erste gelöscht werden und die aktuellen Datenpunkte mit dem Amount im "neuen ersten" Dokument gewichtet werden
              investments.removeAt(0);
              resultAAPL.add(
                FlSpot(
                  singleDP.x,
                  singleDP.y * (investments.first.tokenAmmount),
                ),
              );
            }
          }
        } else {
          //Falls nein bewerten wir jetzt alle restlichen Datenpunkte mit dem Amount des aktuellsten Investmentdokuments
          resultAAPL.add(
            FlSpot(
              singleDP.x,
              singleDP.y * (investments.first.tokenAmmount),
            ),
          );
        }
      }
    }
    print(resultAAPL);
    return resultAAPL;
  }
}
