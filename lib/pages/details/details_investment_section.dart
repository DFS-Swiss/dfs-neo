import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo/widgets/cards/asset_development_card.dart';
import 'package:neo/widgets/development_indicator/detailed_development_indicator.dart';

import '../../hooks/use_stockdata.dart';
import '../../services/formatting_service.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../widgets/genericheadline_widget.dart';

class DetailsInvestmentsSection extends HookWidget {
  final String token;
  const DetailsInvestmentsSection({required this.token, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartDataToday = useState<List<FlSpot>>([]);
    final stockDataToday =
        useStockdata(token, StockdataInterval.twentyFourHours);
    // TODO: We need ALL Stock data here
    final chartDataAllTime = useState<List<FlSpot>>([]);
    final stockDataAllTime = useStockdata(token, StockdataInterval.oneYear);

    useEffect(() {
      if (stockDataToday.loading == false) {
        chartDataToday.value = stockDataToday.data!
            .map((e) =>
                FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
            .toList();
      }

      if (stockDataAllTime.loading == false) {
        chartDataAllTime.value = stockDataAllTime.data!
            .map((e) =>
                FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
            .toList();
      }

      return;
    }, ["_", stockDataToday.loading, stockDataAllTime.loading]);

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
                      chartData: chartDataToday.value,
                    ),
                    AssetDevelopmentCard(
                      name: AppLocalizations.of(context)!.details_performance,
                      chartData: chartDataAllTime.value,
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
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
