import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../types/balance_history_container.dart';
import '../../utils/chart_conversion.dart';

class PortfolioDevelopmentChart extends StatelessWidget {
  final BalanceHistoryContainer data;

  const PortfolioDevelopmentChart({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return data.hasNoInvestments
        ? Center(
            child: Text(
              AppLocalizations.of(context)!.util_no_data,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          )
        : LineChart(
            dashboardPortfolio(
              data.total
                  .map(
                    (e) => FlSpot(
                      e.time.millisecondsSinceEpoch.toDouble(),
                      e.price,
                    ),
                  )
                  .toList(),
              data.inAssets.first.price < data.total.last.price
                  ? true
                  : false,
            ),
          );
  }
}
