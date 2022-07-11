import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../types/balance_history_container.dart';
import '../../utils/chart_conversion.dart';

class PortfolioDevelopmentChart extends StatelessWidget {
  final BalanceHistoryContainer data;

  const PortfolioDevelopmentChart({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: data.hasNoInvestments
          ? Center(
              child: Text(
                "No data avaliable yet...",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            )
          : LineChart(
              dashboardPortfolio(
                data.inAssets
                    .map(
                      (e) => FlSpot(
                        e.time.millisecondsSinceEpoch.toDouble(),
                        e.price,
                      ),
                    )
                    .toList(),
                data.inAssets.first.price < data.inAssets.last.price
                    ? true
                    : false,
              ),
            ),
    );
  }
}
