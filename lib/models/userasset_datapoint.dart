import 'dart:convert';

class UserassetDatapoint {
  final double tokenAmmount;
  final String symbol;
  final double currentValue;
  final DateTime time;
  final double difference;
  UserassetDatapoint({
    required this.tokenAmmount,
    required this.symbol,
    required this.currentValue,
    required this.time,
    required this.difference,
  });

  UserassetDatapoint copyWith({
    double? tokenAmmount,
    String? symbol,
    double? currentValue,
    DateTime? time,
    double? difference,
  }) {
    return UserassetDatapoint(
      tokenAmmount: tokenAmmount ?? this.tokenAmmount,
      symbol: symbol ?? this.symbol,
      currentValue: currentValue ?? this.currentValue,
      time: time ?? this.time,
      difference: difference ?? this.difference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tokenAmmount': tokenAmmount,
      'symbol': symbol,
      'currentValue': currentValue,
      'time': time.millisecondsSinceEpoch,
      'difference': difference,
    };
  }

  factory UserassetDatapoint.fromMap(Map<String, dynamic> map) {
    return UserassetDatapoint(
      tokenAmmount: map['tokenAmmount']?.toDouble() ?? 0.0,
      symbol: map['symbol'] ?? '',
      currentValue: map['currentValue']?.toDouble() ?? 0.0,
      time: DateTime.parse(map['time']),
      difference: map['difference']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserassetDatapoint.fromJson(String source) =>
      UserassetDatapoint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserassetDatapoint(tokenAmmount: $tokenAmmount, symbol: $symbol, currentValue: $currentValue, time: $time, difference: $difference)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserassetDatapoint &&
        other.tokenAmmount == tokenAmmount &&
        other.symbol == symbol &&
        other.currentValue == currentValue &&
        other.time == time &&
        other.difference == difference;
  }

  @override
  int get hashCode {
    return tokenAmmount.hashCode ^
        symbol.hashCode ^
        currentValue.hashCode ^
        time.hashCode ^
        difference.hashCode;
  }
}
