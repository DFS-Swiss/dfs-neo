import 'dart:convert';

class UserassetDatapoint {
  final double tokenAmmount;
  final String symbol;
  final double currentPrice;
  final DateTime time;
  UserassetDatapoint({
    required this.tokenAmmount,
    required this.symbol,
    required this.currentPrice,
    required this.time,
  });

  UserassetDatapoint copyWith({
    double? tokenAmmount,
    String? symbol,
    double? currentPrice,
    DateTime? time,
  }) {
    return UserassetDatapoint(
      tokenAmmount: tokenAmmount ?? this.tokenAmmount,
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'tokenAmmount': tokenAmmount});
    result.addAll({'symbol': symbol});
    result.addAll({'currentPrice': currentPrice});
    result.addAll({'time': time.millisecondsSinceEpoch});
  
    return result;
  }

  factory UserassetDatapoint.fromMap(Map<String, dynamic> map) {
    return UserassetDatapoint(
      tokenAmmount: map['tokenAmmount']?.toDouble() ?? 0.0,
      symbol: map['symbol'] ?? '',
      currentPrice: map['currentPrice']?.toDouble() ?? 0.0,
      time: DateTime.parse(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserassetDatapoint.fromJson(String source) =>
      UserassetDatapoint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserassetDatapoint(tokenAmmount: $tokenAmmount, symbol: $symbol, currentPrice: $currentPrice, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserassetDatapoint &&
      other.tokenAmmount == tokenAmmount &&
      other.symbol == symbol &&
      other.currentPrice == currentPrice &&
      other.time == time;
  }

  @override
  int get hashCode {
    return tokenAmmount.hashCode ^
      symbol.hashCode ^
      currentPrice.hashCode ^
      time.hashCode;
  }
}