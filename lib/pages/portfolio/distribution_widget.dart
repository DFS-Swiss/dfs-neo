import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/pages/portfolio/pie_chart_legend_item.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../hooks/use_user_assets_with_values.dart';
import '../../types/user_asset_datapoint_with_value.dart';

class DistributionWidget extends HookWidget {
  const DistributionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investments = useUserAssetsWithValues();

    List<UserAssetDataWithValue> prepareList() {
      if (investments.data!.length < 6) {
        return investments.data!;
      }
      final out = investments.data!.take(6).toList();

      final restValue = investments.data!.sublist(5).fold<double>(
          0, (previousValue, element) => previousValue + element.totalValue);
      final restAmount = investments.data!.sublist(5).fold<double>(
          0, (previousValue, element) => previousValue + element.tokenAmmount);
      out.add(
        UserAssetDataWithValue(
            tokenAmmount: restAmount,
            symbol: "other",
            currentValue: 0,
            time: DateTime.now(),
            difference: 0,
            totalValue: restValue,
            id: "other"),
      );
      return out;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 170,
        child: !investments.loading
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(170),
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PieChart(
                              PieChartData(
                                sections: prepareList()
                                    .map(
                                      (e) => PieChartSectionData(
                                        value: e.totalValue,
                                        badgeWidget: Container(),
                                        showTitle: false,
                                        radius: 8,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            NumberFormat.currency(symbol: "dUSD ").format(
                                investments.data!.fold<double>(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element.totalValue)),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: investments.data!.isNotEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: prepareList()
                                .map((e) => PieChartLegendItem(data: e))
                                .toList(),
                          )
                        : Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .dashboard_no_investments,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                  )
                ],
              )
            : Shimmer.fromColors(
                baseColor: Color.fromRGBO(238, 238, 238, 0.75),
                highlightColor: Colors.white,
                child: Container(
                  height: 74,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ),
    );
  }
}
