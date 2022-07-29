import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neo/hooks/use_balance_history.dart';
import 'package:neo/hooks/use_chart_scrubbing_state.dart';
import 'package:neo/hooks/use_portfolio_development.dart';
import 'package:neo/pages/dashboard/portfolio_development_chart.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/widgets/hideable_text.dart';
import 'package:neo/widgets/hidebalance_button.dart';
import 'package:neo/widgets/development_indicator/small_change_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:neo/services/formatting_service.dart';

import '../../utils/print_time_for_interval.dart';
import '../development_indicator/detailed_development_indicator.dart';

class PortfolioPerformanceCard extends HookWidget {
  final StockdataInterval interval;
  const PortfolioPerformanceCard({
    Key? key,
    this.interval = StockdataInterval.twentyFourHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceHistory = usePortfolioDevelopment(interval);
    final scrubbingData = useChartScrubbingState();
    return !balanceHistory.loading
        ? Container(
            height: 230,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dash_development,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 30,
                            child: scrubbingData.hasTouch
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      HideableText(
                                        "${FormattingService.roundDouble(scrubbingData.value, 2)}%",
                                        maxLines: 1,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        printTimeForInterval(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              scrubbingData.time.round()),
                                          interval,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      )
                                    ],
                                  )
                                : DetailedDevelopmentIndicator(
                                    fontSize: 20,
                                    iconSize: 30,
                                    changePercentage:
                                        FormattingService.roundDouble(
                                            balanceHistory.data!.perCentChange,
                                            2),
                                    changeValue: FormattingService.roundDouble(
                                        balanceHistory.data!.absoluteChange, 2),
                                    positive:
                                        balanceHistory.data!.perCentChange > 0,
                                  ),
                          )
                        ],
                      ),
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
                    data: balanceHistory.data!.development
                        .map<FlSpot>(
                          (e) => FlSpot(
                            e.time.millisecondsSinceEpoch.toDouble(),
                            e.price,
                          ),
                        )
                        .toList(),
                    positive: balanceHistory.data!.perCentChange < 0,
                  ),
                ),
              ],
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}
