import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/pages/details/details_selectable_widget.dart';
import 'package:neo/utils/display_popup.dart';
import 'package:neo/widgets/buttons/branded_button.dart';
import 'package:neo/widgets/buttons/branded_outline_button.dart';
import 'package:neo/widgets/buttons/round_outline_button.dart';
import 'package:neo/pages/buy_sell/buy_page.dart';
import 'package:neo/widgets/development_indicator/detailed_development_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../hooks/use_chart_scrubbing_state.dart';
import '../../hooks/use_latest_asset_price.dart';
import '../../hooks/use_stockdata.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../services/formatting_service.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../utils/chart_conversion.dart';
import '../../widgets/shimmer_loader_card.dart';
import '../buy_sell/buy_page.dart';
import '../buy_sell/sell_page.dart';

class DetailsDevelopmentSection extends HookWidget {
  final String token;
  const DetailsDevelopmentSection({required this.token, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final interval = useState(StockdataInterval.twentyFourHours);
    final stockData = useStockdata(token, interval.value);
    final symbolInfo = useSymbolInfo(token);
    final latestPrice = useLatestAssetPrice(token);
    final scrubbingData = useChartScrubbingState();

    List<FlSpot> plotData() {
      return stockData.data!
          .map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
          .toList();
    }

    return !symbolInfo.loading && !stockData.loading
        ? Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //Companyimage
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 12, 12, 12),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(symbolInfo.data!.imageUrl),
                          backgroundColor: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                    //Ticker and Companyname
                    Expanded(
                      child: SizedBox(
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
                                scrubbingData.hasTouch
                                    ? "${FormattingService.roundDouble(scrubbingData.value, 2).toString()} dUSD"
                                    : latestPrice.loading
                                        ? "..."
                                        : "${FormattingService.roundDouble(latestPrice.data!, 2).toString()} dUSD",
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
                    ),
                    SizedBox(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            DetailedDevelopmentIndicator(
                              positive: plotData().first.y > plotData().last.y,
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
                              scrubbingData.hasTouch
                                  ? interval.value ==
                                          StockdataInterval.twentyFourHours
                                      ? DateFormat("hh:mm").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                          scrubbingData.time.round(),
                                          isUtc: false,
                                        ).toLocal())
                                      : DateFormat("dd.MM.yyyy").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                          scrubbingData.time.round(),
                                          isUtc: false,
                                        ).toLocal())
                                  : interval.value.toString().toUpperCase(),
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
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: SizedBox(
                    height: 226,
                    child: stockData.refetching
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ))
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 13,
                        child: BrandedOutlineButton(
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
                          child: Text(
                            AppLocalizations.of(context)!.detail_sell,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      RoundOutlineButton(
                          onPressed: () => {displayPopup(context)},
                          child: Icon(
                            Icons.swap_horiz,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 13,
                        child: BrandedButton(
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
                          child: Text(
                            AppLocalizations.of(context)!.detail_buy,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ShimmerLoadingCard(height: 528),
          );
  }
}
