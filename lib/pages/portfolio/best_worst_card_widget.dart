import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_userassets.dart';
import '../../hooks/use_investment_developments.dart';
import '../../types/asset_performance_container.dart';
import '../../types/stockdata_interval_enum.dart';
import 'best_worst_card_element.dart';

class BestWorstCard extends HookWidget {
  const BestWorstCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investments = useUserassets();
    final assetDevelopment =
        useInvestmentDevelopments(StockdataInterval.twentyFourHours);

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
                      assetDevelopment.loading
                          ? BestWorstCardElementPlaceHolder()
                          : BestWorstCardElement(
                              assetDevelopment: getBest(),
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
                      assetDevelopment.loading
                          ? BestWorstCardElementPlaceHolder()
                          : BestWorstCardElement(
                              assetDevelopment: getWorst(),
                            )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
