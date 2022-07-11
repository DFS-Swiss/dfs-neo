import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/widgets/cards/asset_development_card.dart';

import '../../hooks/use_stockdata.dart';
import '../../hooks/use_user_asset_data.dart';
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

    List<FlSpot> plotData(List<StockdataDatapoint> stockData) {
      return stockData
          .map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
          .toList();
    }

    return !stockDataToday.loading &&
            !stockDataAllTime.loading &&
            !investmentData.loading
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GenericHeadline(
                title: AppLocalizations.of(context)!.details_investments,
              ),
              !investmentData.data!.hasNoInvestments
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: AssetDevelopmentCard(
                                  name: AppLocalizations.of(context)!
                                      .details_today,
                                  chartData: plotData(stockDataToday.data!),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: AssetDevelopmentCard(
                                  name: AppLocalizations.of(context)!
                                      .details_performance,
                                  chartData: plotData(stockDataAllTime.data!),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12, 18, 12, 0),
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
                                    investmentData.data!.buyIn.toString(),
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
                                width: 5,
                                thickness: 5,
                                indent: 20,
                                endIndent: 0,
                                color: Color(0xFF909090),
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
                                    investmentData.data!.quantity.toString(),
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
                                width: 5,
                                thickness: 5,
                                indent: 20,
                                endIndent: 0,
                                color: Color(0xFF909090),
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
                                    investmentData.data!.value.toString(),
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
                      ],
                    )
                  : Center(
                    heightFactor: 7,
                      child: Text(AppLocalizations.of(context)!
                          .dashboard_no_investments),
                    )
            ],
          )
        : Container();
  }
}
