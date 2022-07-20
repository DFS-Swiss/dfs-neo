import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:neo/hooks/use_userassets.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/development_indicator/small_change_indicator.dart';

import '../../hooks/use_balance_history.dart';
import '../../hooks/use_investment_developments.dart';
import '../../types/asset_performance_container.dart';
import '../../types/stockdata_interval_enum.dart';

class BestWorstCard extends HookWidget {
  final StockdataInterval interval;

  const BestWorstCard({Key? key, required this.interval}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investments = useUserassets();
    final assetDevelopment = useInvestmentDevelopments(interval);

    AssetPerformanceContainer getBest() {
      assetDevelopment.data!
          .sort((a, b) => a.earnedMoney.compareTo(b.earnedMoney));
      return assetDevelopment.data!.last;
    }

    AssetPerformanceContainer getWorst() {
      assetDevelopment.data!
          .sort((a, b) => a.earnedMoney.compareTo(b.earnedMoney));
      return assetDevelopment.data!.first;
    }

    return investments.loading || investments.data!.length < 2
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.port_overview_best,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        height: 90,
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
                              assetDevelopment.loading
                                  ? "..."
                                  : getBest().symbol,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              assetDevelopment.loading
                                  ? "..."
                                  : "NVDA Coorporation",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  assetDevelopment.loading
                                      ? "..."
                                      : NumberFormat.currency(symbol: "dUSD ")
                                          .format(getBest().earnedMoney),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: assetDevelopment.loading
                                        ? NeoTheme.of(context)!.positiveColor
                                        : getBest().earnedMoney > 0
                                            ? NeoTheme.of(context)!
                                                .positiveColor
                                            : NeoTheme.of(context)!
                                                .negativeColor,
                                  ),
                                ),
                                SmallDevelopmentIndicator(
                                  positive: assetDevelopment.loading
                                      ? true
                                      : getBest().earnedMoney > 0,
                                  changePercentage: assetDevelopment.loading
                                      ? 0
                                      : getBest().differenceInPercent,
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 19,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.port_overview_worst,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        height: 90,
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
                              assetDevelopment.loading
                                  ? "..."
                                  : getWorst().symbol,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              assetDevelopment.loading
                                  ? "..."
                                  : "NVDA Coorporation",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  assetDevelopment.loading
                                      ? "..."
                                      : NumberFormat.currency(symbol: "dUSD ")
                                          .format(getWorst().earnedMoney),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: assetDevelopment.loading
                                        ? NeoTheme.of(context)!.positiveColor
                                        : getWorst().earnedMoney > 0
                                            ? NeoTheme.of(context)!
                                                .positiveColor
                                            : NeoTheme.of(context)!
                                                .negativeColor,
                                  ),
                                ),
                                SmallDevelopmentIndicator(
                                  positive: assetDevelopment.loading
                                      ? true
                                      : getWorst().earnedMoney > 0,
                                  changePercentage: assetDevelopment.loading
                                      ? 0
                                      : getWorst().differenceInPercent,
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
