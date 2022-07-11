import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/cards/asset_development_card.dart';
import 'package:shimmer/shimmer.dart';

import '../../hooks/use_stockdata.dart';
import '../../hooks/use_user_asset_data.dart';
import '../../services/formatting_service.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../widgets/genericheadline_widget.dart';

class DetailsInvestmentsSection extends HookWidget {
  final String token;
  final String symbol;
  const DetailsInvestmentsSection(
      {required this.token, required this.symbol, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockDataToday =
        useStockdata(token, StockdataInterval.twentyFourHours);
    final stockDataAllTime = useStockdata(token, StockdataInterval.oneYear);
    final investmentData = useInvestmentData(token);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GenericHeadline(
          title: AppLocalizations.of(context)!.details_investments,
        ),
        investmentData.loading ||
                stockDataToday.loading ||
                stockDataAllTime.loading
            ? Shimmer.fromColors(
                baseColor: Color.fromRGBO(238, 238, 238, 0.75),
                highlightColor: Colors.white,
                child: Container(
                  height: 139,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : !investmentData.data!.hasNoInvestments
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: AssetDevelopmentCard(
                                name:
                                    AppLocalizations.of(context)!.details_today,
                                changePercentage: investmentData.data!.todayIncreasePercentage,
                                changeValue: investmentData.data!.todayIncrease,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: AssetDevelopmentCard(
                                name: AppLocalizations.of(context)!
                                    .details_performance,
                                changePercentage: investmentData.data!.performancePercentage,
                                changeValue: investmentData.data!.performance,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 18, 12, 0),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.details_buy_in,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF909090),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${FormattingService.roundDouble(investmentData.data!.buyIn, 2).toString()} d\$",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                width: 1,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                                color: Color.fromRGBO(32, 209, 209, 1),
                              ),
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .details_quantity,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF909090),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    FormattingService.roundDouble(
                                            investmentData.data!.quantity, 2)
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                width: 1,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                                color: Color.fromRGBO(32, 209, 209, 1),
                              ),
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.details_value,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF909090),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${FormattingService.roundDouble(investmentData.data!.value, 2).toString()} d\$",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    heightFactor: 7,
                    child: Text(
                        AppLocalizations.of(context)!.dashboard_no_investments),
                  ),
      ],
    );
  }
}
