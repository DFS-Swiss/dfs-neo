import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_stockdata.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/utils/formatting_utils.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/chart_conversion.dart';
import 'package:neo/widgets/development_indicator/small_change_indicator.dart';
import '../shimmer_loader_card.dart';

class TradableStockCard extends HookWidget {
  final String token;

  const TradableStockCard({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final chartData = useState<List<FlSpot>>([]);
      final stockData = useStockdata(token, StockdataInterval.twentyFourHours);
      final symbolInfo = useSymbolInfo(token);

      useEffect(() {
        if (!stockData.loading) {
          chartData.value = stockData.data!
              .map((e) =>
                  FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
              .toList();
        }

        return;
      }, ["_", stockData.loading]);

      return !symbolInfo.loading &&
              !stockData.loading 
          ? Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
              child: Container(
                height: 74,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //Companyimage
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          key: ValueKey(symbolInfo.data!.imageUrl),
                          backgroundImage: CachedNetworkImageProvider(
                            symbolInfo.data!.imageUrl,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    //Ticker and Companyname
                    SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            stockData.data!.first.symbol,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: 70, minWidth: 70),
                            child: Text(
                              symbolInfo.data!.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(),
                    ),
                    //Graph
                    SizedBox(
                      //height: 100,
                      width: 96,
                      //width: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 24, bottom: 24),
                        child: LineChart(preview(
                          chartData.value,
                          chartData.value.first.y < chartData.value.last.y
                              ? true
                              : false,
                        )),
                      ),
                    ),
                    Expanded(
                      flex: 13,
                      child: Container(),
                    ),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "d\$${FormattingUtils.roundDouble(stockData.data!.first.price, 2).toString()}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            SmallDevelopmentIndicator(
                              positive: chartData.value.first.y >
                                  chartData.value.last.y,
                              changePercentage:
                                  FormattingUtils.calculatepercent(
                                      chartData.value.first.y,
                                      chartData.value.last.y),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
              child: ShimmerLoadingCard(height: 74),
            );
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Container(
          alignment: Alignment.center,
          height: 74,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.error_outline,
                  size: 55,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  "We are currently having technical problems displaying $token",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF909090),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
