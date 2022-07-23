import 'package:neo/types/stockdata_interval_enum.dart';

//TODO: Calculations potentially inaccurate. Need to be replaced with a proper library eventually.
DateTime getStartOfInterval(StockdataInterval interval) {
  switch (interval) {
    case StockdataInterval.twentyFourHours:
      return DateTime.now().subtract(Duration(days: 1));
    case StockdataInterval.mtd:
      return DateTime.now().subtract(Duration(days: DateTime.now().day));
    case StockdataInterval.ytd:
      return DateTime.now().subtract(Duration(days: 365 * DateTime.now().day));
    case StockdataInterval.oneYear:
      return DateTime(
          DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    case StockdataInterval.twoYears:
      return DateTime(
          DateTime.now().year - 2, DateTime.now().month, DateTime.now().day);
  }
}
