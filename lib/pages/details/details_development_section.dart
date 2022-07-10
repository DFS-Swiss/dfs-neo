import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/details/details_selectable_widget.dart';
import 'package:neo/widgets/buttons/branded_button.dart';
import 'package:neo/widgets/buttons/branded_outline_button.dart';
import 'package:neo/widgets/buttons/round_outline_button.dart';
import 'package:neo/widgets/development_indicator/detailed_development_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import '../../hooks/use_stockdata.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../services/formatting_service.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../utils/chart_conversion.dart';

class DetailsDevelopmentSection extends HookWidget {
  final String token;
  const DetailsDevelopmentSection({required this.token, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final interval = useState(StockdataInterval.ytd);
    final stockData = useStockdata(token, interval.value);
    final symbolInfo = useSymbolInfo(token);

    List<FlSpot> plotData() {
      return stockData.data!
          .map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
          .toList();
    }

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
                              DetailedDevelopmentIndicator(
                                positive:
                                    plotData().first.y > plotData().last.y,
                                changePercentage:
                                    FormattingService.calculatepercent(
                                        plotData().first.y, plotData().last.y),
                                changeValue: FormattingService.roundDouble(
                                    plotData().first.y - plotData().last.y, 2),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                interval.value.toString(),
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
                  DetailsSelectable(
                    callback: (Object selectedInterval) {
                      interval.value = selectedInterval as StockdataInterval;
                    },
                    currentValue: interval.value,
                  ),
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
                                plotData(),
                                plotData().first.y < plotData().last.y
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
                        Expanded(
                          flex: 13,
                          child: BrandedOutlineButton(
                            onPressed: () => {},
                            child: Text(
                              AppLocalizations.of(context)!.detail_sell,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RoundOutlineButton(
                            onPressed: () => {},
                            child: Icon(Icons.swap_horiz, color: Theme.of(context).primaryColor, size: 30,)),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 13,
                          child: BrandedButton(
                            onPressed: () => {},
                            child: Text(
                              AppLocalizations.of(context)!.detail_buy,
                            ),
                          ),
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
