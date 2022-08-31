import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_userassets.dart';
import 'package:neo/widgets/cards/asset_development_card.dart';
import '../../hooks/use_stockdata.dart';
import '../../hooks/use_user_assets_for_symbol.dart';
import '../../utils/formatting_utils.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../widgets/genericheadline_widget.dart';
import '../../widgets/shimmer_loader_card.dart';

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
    //final stockDataAllTime = useStockdata(token, StockdataInterval.oneYear);
    final investmentData = useUserAssetsForSymbol(token);
    final userInvestments = useUserassets();

    bool showData() {
      return userInvestments.data!
              .where((element) => element.symbol == symbol)
              .isNotEmpty &&
          !investmentData.loading &&
          !stockDataToday.loading &&
          !investmentData.refetching &&
          !stockDataToday.refetching;
      //&& !stockDataAllTime.loading;
    }

    bool showNothing() {
      return userInvestments.data!
          .where((element) => element.symbol == symbol)
          .isEmpty;
    }

    return !userInvestments.loading && !userInvestments.refetching
        ? showData()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GenericHeadline(
                    title: AppLocalizations.of(context)!.details_investments,
                  ),
                  Column(
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
                                changePercentage: investmentData
                                    .data!.todayIncreasePercentage,
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
                                changePercentage:
                                    investmentData.data!.performancePercentage,
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
                                    AppLocalizations.of(context)!
                                        .details_buy_in,
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
                                    "${FormattingUtils.roundDouble(investmentData.data!.buyIn, 2).toString()} d\$",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .color,
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
                                    FormattingUtils.roundDouble(
                                            investmentData.data!.quantity, 2)
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .color,
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
                                    "${FormattingUtils.roundDouble(investmentData.data!.value, 2).toString()} d\$",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .color,
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
                ],
              )
            : showNothing()
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ShimmerLoadingCard(height: 528))
        : Container();
  }
}
