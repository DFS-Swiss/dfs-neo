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

  String toJson() {
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

  static StockdataInterval fromString(String interval) {
    switch (interval) {
      case "mtd":
        return StockdataInterval.mtd;
      case "ytd":
        return StockdataInterval.ytd;
      case "24h":
        return StockdataInterval.twentyFourHours;
      case "2years":
        return StockdataInterval.twoYears;
      case "1year":
        return StockdataInterval.oneYear;
      default:
        throw "Unknown state";
    }
  }
}
