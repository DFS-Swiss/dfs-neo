import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../utils/chart_conversion.dart';

class PortfolioDevelopmentChart extends StatelessWidget {
  //final BalanceHistoryContainer data;
  final List<FlSpot> data;
  final bool positive;

  const PortfolioDevelopmentChart(
      {Key? key, required this.data, required this.positive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: data.isEmpty
          ? Center(
            child: Text(
              AppLocalizations.of(context)!.util_no_data,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          )
          : LineChart(
              dashboardPortfolio(
                data,
                positive,
              ),
            ),
          );
  }
}
