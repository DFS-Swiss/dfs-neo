import 'package:neo/models/userasset_datapoint.dart';

class UserAssetDataWithValue extends UserassetDatapoint {
  final double totalValue;
  UserAssetDataWithValue({
    required super.tokenAmmount,
    required super.symbol,
    required super.currentValue,
    required super.time,
    required super.difference,
    required this.totalValue,
    required super.id,
  });

  factory UserAssetDataWithValue.fromUserAssetDataPoint(
      UserassetDatapoint datapoint, double totalValue) {
    return UserAssetDataWithValue(
      tokenAmmount: datapoint.tokenAmmount,
      symbol: datapoint.symbol,
      currentValue: datapoint.currentValue,
      time: datapoint.time,
      difference: datapoint.difference,
      totalValue: totalValue,
      id: datapoint.id,
    );
  }
}
