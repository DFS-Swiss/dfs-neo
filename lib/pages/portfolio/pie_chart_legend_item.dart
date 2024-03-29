import 'package:flutter/material.dart';
import 'package:neo/types/user_asset_datapoint_with_value.dart';

import '../../widgets/hideable_text.dart';

class PieChartLegendItem extends StatelessWidget {
  final UserAssetDataWithValue data;
  final Color displayColor;
  final double totalAmountInvested;
  const PieChartLegendItem(
      {Key? key,
      required this.data,
      required this.displayColor,
      required this.totalAmountInvested})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: displayColor, borderRadius: BorderRadius.circular(4)),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            data.symbol,
            style: Theme.of(context).textTheme.labelSmall,
          )),
          HideableText(
            "${((data.totalValue / totalAmountInvested) * 100).toStringAsFixed(2)} %",
            //NumberFormat.currency(symbol: "dUSD ").format(data.totalValue),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
