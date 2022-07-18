import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/buy_sell/buy_page.dart';
import 'package:neo/widgets/branded_button.dart';
import 'package:neo/widgets/development_indicator/detailed_development_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import '../../hooks/use_stockdata.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../services/formatting_service.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../utils/chart_conversion.dart';
import '../buy_sell/sell_page.dart';

class DetailsDevelopmentSection extends HookWidget {
  final String token;
  const DetailsDevelopmentSection({required this.token, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartData = useState<List<FlSpot>>([]);
    final stockData = useStockdata(token, StockdataInterval.ytd);
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

    return !symbolInfo.loading && !stockData.loading
        ? Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //Companyimage
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(symbolInfo.data!.imageUrl),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      //Ticker and Companyname
                      SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              symbolInfo.data!.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: 150, minWidth: 70),
                              child: Text(
                                "${FormattingService.roundDouble(stockData.data!.first.price, 2).toString()} dUSD",
                                style: TextStyle(
                                  fontSize: 20,
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
                        flex: 13,
                        child: Container(),
                      ),
                      SizedBox(
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              // TODO: This needs to be dependent on the selection of the chart
                              DetailedDevelopmentIndicator(
                                positive: chartData.value.first.y >
                                    chartData.value.last.y,
                                changePercentage:
                                    FormattingService.calculatepercent(
                                        chartData.value.first.y,
                                        chartData.value.last.y),
                                changeValue: FormattingService.roundDouble(
                                    chartData.value.first.y -
                                        chartData.value.last.y,
                                    2),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "YTD",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF909090),
                                ),
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
                  // Filter
                  // Chart
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 200,
                      child: stockData.loading
                          ? Center(
                              child: Text(
                                "No data avaliable yet...",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            )
                          : LineChart(
                              details(
                                chartData.value,
                                chartData.value.first.y < chartData.value.last.y
                                    ? true
                                    : false,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        BrandedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellPage(
                                  symbol: token,
                                ),
                              ),
                            )
                          },
                          child:
                              Text(AppLocalizations.of(context)!.detail_sell),
                        ),
                        Expanded(
                          flex: 13,
                          child: Container(),
                        ),
                        BrandedButton(
                          onPressed: () => {},
                          child: Icon(
                            Icons.swap_horiz,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 13,
                          child: Container(),
                        ),
                        BrandedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyPage(
                                  symbol: token,
                                ),
                              ),
                            )
                          },
                          child: Text(AppLocalizations.of(context)!.detail_buy),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              height: 370,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}
