import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

class StockdataStorageContainer {
  final StockdataInterval interval;
  final String symbol;
  final Map<DateTime, StockdataDatapoint> _data = {};
  DateTime lastSync;

  StockdataStorageContainer(
      this.interval, this.symbol, List<StockdataDatapoint> data)
      : lastSync = DateTime.now() {
    merge(data, initial: true);
  }

  List<StockdataDatapoint> getSorted() {
    final temp = _data.values.toList();
    temp.sort((a, b) => b.time.compareTo(a.time));
    return temp;
  }

  merge(List<StockdataDatapoint> newDatapoints, {bool initial = false}) {
    lastSync = DateTime.now();
    final Map<DateTime, StockdataDatapoint> temp = {};
    for (var element in newDatapoints) {
      temp[element.time] = element;
    }
    _data.addAll(temp);
  }

  bool isStale() {
    return lastSync.difference(DateTime.now()).inMinutes > 10;
  }
}
