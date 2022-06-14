enum StockdataInterval {
  ytd,
  oneYear,
  mtd,
  twentyFourHours,
  twoYears;

  @override
  String toString() {
    switch (this) {
      case StockdataInterval.mtd:
        return "mtd";
      case StockdataInterval.ytd:
        return "ytd";
      case StockdataInterval.twentyFourHours:
        return "24h";
      case StockdataInterval.twoYears:
        return "2years";
      case StockdataInterval.oneYear:
        return "1year";
      default:
        throw "Unknown state";
    }
  }
}
