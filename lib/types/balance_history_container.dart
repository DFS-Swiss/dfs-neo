import 'package:neo/types/price_development_datapoint.dart';

class BalanceHistoryContainer {
  final List<PriceDevelopmentDatapoint> total;
  final List<PriceDevelopmentDatapoint> inAssets;
  final double inCash;
  final double averagePL;

  final bool portfolioIsEmpty;
  final bool hasNoInvestments;

  BalanceHistoryContainer({
    required this.total,
    required this.inAssets,
    required this.inCash,
    required this.averagePL,
    this.portfolioIsEmpty = false,
    this.hasNoInvestments = false,
  });
}
