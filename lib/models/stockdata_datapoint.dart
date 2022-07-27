import 'dart:convert';

class StockdataDatapoint {
  final DateTime time;
  final double price;
  final String symbol;

  StockdataDatapoint(
    this.time,
    this.price,
    this.symbol,
  );

  StockdataDatapoint copyWith({
    DateTime? time,
    double? price,
    String? symbol,
  }) {
    return StockdataDatapoint(
      time ?? this.time,
      price ?? this.price,
      symbol ?? this.symbol,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time.millisecondsSinceEpoch,
      'price': price,
      'symbol': symbol,
    };
  }

  factory StockdataDatapoint.fromMap(Map<String, dynamic> map) {
    return StockdataDatapoint(
      DateTime.parse(map['time']).add(DateTime.now().timeZoneOffset),
      map['price']?.toDouble() ?? 0.0,
      map['symbol'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StockdataDatapoint.fromJson(String source) =>
      StockdataDatapoint.fromMap(json.decode(source));

  @override
  String toString() =>
      'StockdataDatapoint(time: $time, price: $price, symbol: $symbol)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockdataDatapoint &&
        other.time == time &&
        other.price == price &&
        other.symbol == symbol;
  }

  @override
  int get hashCode => time.hashCode ^ price.hashCode ^ symbol.hashCode;
}
