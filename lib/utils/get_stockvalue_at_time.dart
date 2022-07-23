import 'package:neo/models/stockdata_datapoint.dart';

StockdataDatapoint getStockValueAtTime(
    List<StockdataDatapoint> stockData, DateTime time) {
  return stockData
      .where((element) =>
          element.time.millisecondsSinceEpoch < time.millisecondsSinceEpoch)
      .last;
}
