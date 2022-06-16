import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_stockdata.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/services/formatting_service.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/chart_conversion.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedStockCard extends HookWidget {
  final String token;
  const FeaturedStockCard({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartData = useState<List<FlSpot>>([]);
    final stockData = useStockdata(token, StockdataInterval.twentyFourHours);
    final symbolInfo = useSymbolInfo(token);
    useEffect(() {
      if (stockData.loading == false) {
        chartData.value = stockData.data!
            .map((e) =>
                FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
            .toList();
      }

      return;
    }, ["_", stockData.loading]);

    return stockData.loading == false && symbolInfo.loading == false
        ? Container(
            height: 139,
            width: 210,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Row for Icon; Symbol, Companyname, currentprice and growth in percent
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        //Image
                        SizedBox(
                          width: 38,
                          height: 38,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(symbolInfo.data!.imageUrl),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        //Ticker and Companyname
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              stockData.data!.first.symbol,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              symbolInfo.data!.displayName,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        //Current Value and growth in %
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "\$${FormattingService.roundDouble(stockData.data!.last.price, 2).toString()}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "${FormattingService.calculatepercent(chartData.value.first.y, chartData.value.last.y)}%",
                              style: TextStyle(
                                fontSize: 12,
                                color: chartData.value.first.y >
                                        chartData.value.last.y
                                    ? NeoTheme.of(context)!.positiveColor
                                    : NeoTheme.of(context)!.negativeColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //Stock Graph
                SizedBox(
                  height: 70,
                  //width: 100,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 15),
                    child: LineChart(preview(
                      chartData.value,
                      chartData.value.first.y < chartData.value.last.y
                          ? true
                          : false,
                    )),
                  ),
                ),
              ],
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              width: 210,
              height: 139,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ));
  }
}
