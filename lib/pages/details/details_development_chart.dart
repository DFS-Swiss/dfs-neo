import 'package:flutter/material.dart';

class DetailsDevelopmentChart extends StatelessWidget {
  const DetailsDevelopmentChart({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      /*
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
            */
    );
  }
}
