import 'dart:convert';

class StockdataDocument {

  final String symbol;
  final String displayName;
  final String imageUrl;
  final String description;
  StockdataDocument({
    required this.symbol,
    required this.displayName,
    required this.imageUrl,
    required this.description,
  });
  

  StockdataDocument copyWith({
    String? symbol,
    String? displayName,
    String? imageUrl,
    String? description,
  }) {
    return StockdataDocument(
      symbol: symbol ?? this.symbol,
      displayName: displayName ?? this.displayName,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'symbol': symbol});
    result.addAll({'displayName': displayName});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'description': description});
  
    return result;
  }

  factory StockdataDocument.fromMap(Map<String, dynamic> map) {
    return StockdataDocument(
      symbol: map['symbol'] ?? '',
      displayName: map['displayName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StockdataDocument.fromJson(String source) => StockdataDocument.fromMap(json.decode(source));

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
      other.description == description;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
      displayName.hashCode ^
      imageUrl.hashCode ^
      description.hashCode;
  }
}
