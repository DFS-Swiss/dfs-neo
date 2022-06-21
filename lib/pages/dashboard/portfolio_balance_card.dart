import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo/hooks/use_balance_history.dart';
import 'package:neo/pages/dashboard/portfolio_development_chart.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/widgets/hideable_text.dart';
import 'package:neo/widgets/hidebalance_button.dart';
import 'package:neo/widgets/small_change_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:neo/services/formatting_service.dart';

class PortfolioBalanceCard extends HookWidget {
  const PortfolioBalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceHistory = useBalanceHistory(StockdataInterval.twentyFourHours);
    return !balanceHistory.loading
        ? Container(
            height: 270,
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
                    Column(
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
                          "${FormattingService.roundDouble(balanceHistory.data!.portfolioIsEmpty ? 0 : balanceHistory.data!.total.first.price, 2)} USD",
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dash_pl_lable,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SmallDevelopmentIndicator(
                              positive: balanceHistory.data!.averagePL > 0,
                              changePercentage: FormattingService.roundDouble(
                                  balanceHistory.data!.averagePL, 2),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dash_today,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SmallDevelopmentIndicator(
                              positive:
                                  balanceHistory.data!.inAssets.first.price >
                                      balanceHistory.data!.inAssets.last.price,
                              changePercentage: balanceHistory
                                      .data!.hasNoInvestments
                                  ? 0
                                  : FormattingService.calculatepercent(
                                      balanceHistory.data!.inAssets.first.price,
                                      balanceHistory.data!.inAssets.last.price,
                                    ),
                            )
                          ],
                        )
                      ],
                    ),
                    HideBalanceButton()
                  ],
                ),
                SizedBox(
                  height: 19.5,
                ),
                Container(
                  height: 108,
                  child: PortfolioDevelopmentChart(data: balanceHistory.data!),
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
                          "${FormattingService.roundDouble(balanceHistory.data!.inCash, 2)} USD",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        HideableText(
                          "${FormattingService.roundDouble(balanceHistory.data!.inAssets.first.price, 2)} USD",
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
                          AppLocalizations.of(context)!.dash_locked_oo,
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
