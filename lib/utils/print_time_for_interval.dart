import 'package:intl/intl.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

String printTimeForInterval(DateTime time, StockdataInterval interval) {
  return interval == StockdataInterval.twentyFourHours
      ? DateFormat("hh:mm").format(time.toLocal())
      : DateFormat("dd.MM.yyyy").format(
          time.toLocal(),
        );
}
