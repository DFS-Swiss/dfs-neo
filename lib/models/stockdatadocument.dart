import 'dart:convert';

import 'package:flutter/material.dart';

class StockdataDocument {
  final String symbol;
  final String displayName;
  final String imageUrl;
  final String description;
  final int publicSentimentIndex;
  final Color displayColor;

  StockdataDocument(
      {required this.symbol,
      required this.displayName,
      required this.imageUrl,
      required this.description,
      required this.publicSentimentIndex,
      required this.displayColor});

  StockdataDocument copyWith(
      {String? symbol,
      String? displayName,
      String? imageUrl,
      String? description,
      int? publicSentimentIndex,
      Color? displayColor}) {
    return StockdataDocument(
        symbol: symbol ?? this.symbol,
        displayName: displayName ?? this.displayName,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        publicSentimentIndex: publicSentimentIndex ?? this.publicSentimentIndex,
        displayColor: displayColor ?? this.displayColor);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'symbol': symbol});
    result.addAll({'displayName': displayName});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'description': description});
    result.addAll({'publicSentimentIndex': publicSentimentIndex});
    result.addAll({'displayColor': displayColor.value});
    return result;
  }

  factory StockdataDocument.fromMap(Map<String, dynamic> map) {
    return StockdataDocument(
        symbol: map['symbol'] ?? '',
        displayName: map['displayName'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        description: map['description'] ?? '',
        publicSentimentIndex: map['publicSentimentIndex'] ?? 50,
        displayColor: map['displayColor'] != null
            ? Color(int.parse(map['displayColor']))
            : Colors.grey);
  }

  String toJson() => json.encode(toMap());

  factory StockdataDocument.fromJson(String source) =>
      StockdataDocument.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockdataDocument(symbol: $symbol, displayName: $displayName, imageUrl: $imageUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockdataDocument &&
        other.symbol == symbol &&
        other.displayName == displayName &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.publicSentimentIndex == publicSentimentIndex;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
        displayName.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        publicSentimentIndex.hashCode;
  }
}
