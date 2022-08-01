import 'package:neo/types/stockdata_interval_enum.dart';

class AssetPerformanceContainer {
  String symbol;
  StockdataInterval interval;
  double earnedMoney;
  double differenceInPercent;
  double absoluteChange;
  AssetPerformanceContainer(
      {required this.symbol,
      required this.interval,
      required this.earnedMoney,
      required this.differenceInPercent,
      required this.absoluteChange});
}
