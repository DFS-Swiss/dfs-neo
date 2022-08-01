import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:neo/types/stockdata_interval_enum.dart';

class StockdataBulkFetchRequest {
  final Map<String, List<StockdataInterval>> symbols;
  StockdataBulkFetchRequest({
    required this.symbols,
  });

  StockdataBulkFetchRequest copyWith({
    Map<String, List<StockdataInterval>>? symbols,
  }) {
    return StockdataBulkFetchRequest(
      symbols: symbols ?? this.symbols,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbols': symbols,
    };
  }

  factory StockdataBulkFetchRequest.fromMap(Map<String, dynamic> map) {
    return StockdataBulkFetchRequest(
      symbols: Map<String, List<StockdataInterval>>.from(map['symbols']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StockdataBulkFetchRequest.fromJson(String source) =>
      StockdataBulkFetchRequest.fromMap(json.decode(source));

  @override
  String toString() => 'StockdataBulkFetchRequest(symbols: $symbols)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockdataBulkFetchRequest &&
        mapEquals(other.symbols, symbols);
  }

  @override
  int get hashCode => symbols.hashCode;
}
