import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo/hooks/use_balance_history.dart';
import 'package:neo/hooks/use_chart_scrubbing_state.dart';
import 'package:neo/pages/dashboard/portfolio_development_chart.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/print_time_for_interval.dart';
import 'package:neo/widgets/hideable_text.dart';
import 'package:neo/widgets/hidebalance_button.dart';
import 'package:neo/widgets/development_indicator/small_change_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:neo/services/formatting_service.dart';

class PortfolioBalanceCard extends HookWidget {
  final StockdataInterval interval;
  const PortfolioBalanceCard({
    Key? key,
    this.interval = StockdataInterval.twentyFourHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceHistory = useBalanceHistory(interval);
    final scrubbingData = useChartScrubbingState();
    return !balanceHistory.loading
        ? Container(
            height: 278,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dash_balance,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          HideableText(
                            scrubbingData.hasTouch
                                ? "${FormattingService.roundDouble(scrubbingData.value, 2)} dUSD"
                                : "${FormattingService.roundDouble(balanceHistory.data!.portfolioIsEmpty ? 0 : balanceHistory.data!.total.first.price, 2)} dUSD",
                            maxLines: 1,
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .dash_portofolio_change,
                                style: Theme.of(context).textTheme.labelSmall),
                            SizedBox(
                              width: 0,
                            ),
                            SmallDevelopmentIndicator(
                              isInPercent: false,
                              hideable: true,
                              positive: balanceHistory.data!.total.first.price >
                                  balanceHistory.data!.total.last.price,
                              changePercentage: FormattingService.roundDouble(
                                  balanceHistory.data!.total.first.price -
                                      balanceHistory.data!.total.last.price,
                                  2),
                              prefix: "d\$ ",
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                          child: !scrubbingData.hasTouch
                              ? Row(
                                  children: [
                                    Text((interval).toString().toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    SmallDevelopmentIndicator(
                                      hideable: true,
                                      positive: balanceHistory
                                              .data!.total.first.price >
                                          balanceHistory.data!.total.last.price,
                                      changePercentage: balanceHistory
                                              .data!.hasNoInvestments
                                          ? 0
                                          : FormattingService.calculatepercent(
                                              balanceHistory
                                                  .data!.total.first.price,
                                              balanceHistory.data!.total
                                                  .lastWhere((element) =>
                                                      element.price > 0)
                                                  .price,
                                            ),
                                    )
                                  ],
                                )
                              : Text(
                                  printTimeForInterval(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          scrubbingData.time.round()),
                                      interval),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF909090),
                                  ),
                                ),
                        )
                      ],
                    ),
                    HideBalanceButton()
                  ],
                ),
                SizedBox(
                  height: 19.5,
                ),
                SizedBox(
                  height: 108,
                  child: PortfolioDevelopmentChart(
                    data: balanceHistory.data!.total
                        .map<FlSpot>(
                          (e) => FlSpot(
                            e.time.millisecondsSinceEpoch.toDouble(),
                            e.price,
                          ),
                        )
                        .toList(),
                    positive: balanceHistory.data!.total.first.price <
                            balanceHistory.data!.total.last.price
                        ? true
                        : false,
                  ),
                ),
                SizedBox(
                  height: 19.5,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HideableText(
                          "${FormattingService.roundDouble(balanceHistory.data!.inCash, 2)} dUSD",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        HideableText(
                          "${FormattingService.roundDouble(balanceHistory.data!.inAssets.first.price, 2)} dUSD",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dash_available,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)!.dash_currently_invested,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              height: 270,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}
