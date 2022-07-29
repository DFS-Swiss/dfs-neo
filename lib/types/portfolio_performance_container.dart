import 'package:neo/types/price_development_datapoint.dart';

class PortfolioPerformanceContainer {
  final double absoluteChange;
  final double perCentChange;
  final List<PriceDevelopmentDatapoint> development;

  PortfolioPerformanceContainer({
    required this.absoluteChange,
    required this.perCentChange,
    required this.development,
  });
}
