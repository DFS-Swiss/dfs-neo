import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/pages/details/details_page.dart';
import 'package:neo/types/asset_performance_container.dart';

import '../../style/theme.dart';
import '../../widgets/development_indicator/small_change_indicator.dart';
import '../../widgets/hideable_text.dart';

class BestWorstCardElement extends HookWidget {
  const BestWorstCardElement({Key? key, required this.assetDevelopment})
      : super(key: key);

  final AssetPerformanceContainer assetDevelopment;

  @override
  Widget build(BuildContext context) {
    final symbolInfo = useSymbolInfo(assetDevelopment.symbol);

    return GestureDetector(
      onTap: (() => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(token: assetDevelopment.symbol)))),
      child: Container(
        height: 97,
        padding: EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assetDevelopment.symbol,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              symbolInfo.loading ? "..." : symbolInfo.data!.displayName,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HideableText(
                  NumberFormat.currency(symbol: "dUSD ")
                      .format(assetDevelopment.earnedMoney),
                  style: TextStyle(
                    fontSize: 13,
                    color: assetDevelopment.earnedMoney > 0
                        ? NeoTheme.of(context)!.positiveColor
                        : NeoTheme.of(context)!.negativeColor,
                  ),
                ),
                SmallDevelopmentIndicator(
                  positive: assetDevelopment.earnedMoney > 0,
                  changePercentage: assetDevelopment.differenceInPercent,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BestWorstCardElementPlaceHolder extends StatelessWidget {
  const BestWorstCardElementPlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "...",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "...",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "...",
                style: TextStyle(
                    fontSize: 14, color: NeoTheme.of(context)!.positiveColor),
              ),
              SmallDevelopmentIndicator(
                positive: true,
                changePercentage: 0,
              )
            ],
          )
        ],
      ),
    );
  }
}
