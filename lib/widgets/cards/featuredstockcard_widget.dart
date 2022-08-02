import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_stockdata.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/services/formatting_service.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/chart_conversion.dart';
import 'package:neo/widgets/shimmer_loader_card.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedStockCard extends HookWidget {
  final String token;
  const FeaturedStockCard({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockData = useStockdata(token, StockdataInterval.twentyFourHours);
    final symbolInfo = useSymbolInfo(token);

    return stockData.loading == false && symbolInfo.loading == false
        ? Container(
            height: 139,
            width: 210,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(12),
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
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              symbolInfo.data!.imageUrl,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        //Ticker and Companyname
                        Expanded(
                          child: Column(
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
                                maxLines: 1,
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
                        ),
                        //Current Value and growth in %
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "d\$${FormattingService.roundDouble(stockData.data!.first.price, 2).toString()}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "${FormattingService.calculatepercent(stockData.data!.first.price, stockData.data!.last.price)}%",
                              style: TextStyle(
                                fontSize: 12,
                                color: stockData.data!.first.price >
                                        stockData.data!.last.price
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
                    child: LineChart(
                      preview(
                        stockData.data!
                            .map((e) => FlSpot(
                                e.time.millisecondsSinceEpoch.toDouble(),
                                e.price))
                            .toList(),
                        stockData.data!.first.price < stockData.data!.last.price
                            ? true
                            : false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : ShimmerLoadingCard(
            width: 210,
            height: 139,
          );
  }
}
