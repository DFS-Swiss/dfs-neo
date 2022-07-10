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
    final userAssetData = useUserAssetData(symbol);

    double buyIn = 0;
    double quantity = 0;
    double value = 0;
    useEffect(() {
      userAssetData.data?.forEach((element) {
        quantity += element.tokenAmmount;
        value += element.currentValue;
        
       });
      return;
    }, ["_", userAssetData.loading]);

    List<FlSpot> plotData(List<StockdataDatapoint> stockData) {
      return stockData
          .map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
          .toList();
    }

    return !stockDataToday.loading && !stockDataAllTime.loading
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GenericHeadline(
                title: AppLocalizations.of(context)!.details_investments,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AssetDevelopmentCard(
                      name: AppLocalizations.of(context)!.details_today,
                      chartData: plotData(stockDataToday.data!),
                    ),
                    AssetDevelopmentCard(
                      name: AppLocalizations.of(context)!.details_performance,
                      chartData: plotData(stockDataAllTime.data!),
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
                          AppLocalizations.of(context)!.details_buy_in,
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
                        Text(
                          AppLocalizations.of(context)!.details_value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
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
                          AppLocalizations.of(context)!.details_quantity,
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
                        Text(
                          quantity.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
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
                            fontSize: 16,
                            color: Color(0xFF909090),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          value.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
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
        : Container();
  }
}
