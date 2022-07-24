import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/details/details_page.dart';
import 'package:neo/widgets/development_indicator/small_change_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../hooks/use_stockdata.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../hooks/use_userassets.dart';
import '../../models/userasset_datapoint.dart';
import '../../services/formatting_service.dart';
import '../../style/theme.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../utils/chart_conversion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../hideable_text.dart';

class InvestmentCard extends HookWidget {
  final String token;
  final bool expandHorizontal;
  final StockdataInterval interval;
  const InvestmentCard(
      {Key? key,
      required this.token,
      this.expandHorizontal = false,
      this.interval = StockdataInterval.twentyFourHours})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockData = useStockdata(token, interval);
    final symbolInfo = useSymbolInfo(token);
    final assests = useUserassets();

    UserassetDatapoint relevantInvestment(List<UserassetDatapoint> list) {
      return list.firstWhere((element) => element.symbol == token);
    }

    return !stockData.loading && !symbolInfo.loading && !assests.loading
        ? GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(token: token),
              ),
            ),
            child: Container(
              height: 139,
              width: !expandHorizontal ? 210 : double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                children: [
                  //Row for Icon; Symbol, Companyname, currentprice and growth in percent
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 38,
                              height: 38,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(symbolInfo.data!.imageUrl),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            //Ticker and Companyname
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    !stockData.loading && stockData.data != null
                                        ? stockData.data!.first.symbol
                                        : "...",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  HideableText(
                                    "${FormattingService.roundDouble(relevantInvestment(assests.data!).tokenAmmount, 2)} ${AppLocalizations.of(context)!.dash_currinv_amount_multiple}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF909090),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: LineChart(
                            preview(
                              stockData.data!
                                  .map((e) => FlSpot(
                                      e.time.millisecondsSinceEpoch.toDouble(),
                                      e.price))
                                  .toList(),
                              stockData.data!.first.price <
                                      stockData.data!.last.price
                                  ? true
                                  : false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          HideableText(
                            "\$${FormattingService.roundDouble(stockData.data!.first.price * relevantInvestment(assests.data!).tokenAmmount, 2).toString()}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${FormattingService.calculatepercent(stockData.data!.first.price, stockData.data!.last.price)}%",
                            style: TextStyle(
                              fontSize: 12,
                              color: stockData.data!.first.price >
                                      stockData.data!.last.price
                                  ? NeoTheme.of(context)!.positiveColor
                                  : NeoTheme.of(context)!.negativeColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "\$${FormattingService.roundDouble(stockData.data!.first.price, 2).toString()}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SmallDevelopmentIndicator(
                            positive: stockData.data!.first.price >
                                stockData.data!.last.price,
                            changePercentage:
                                FormattingService.calculatepercent(
                                    stockData.data!.first.price,
                                    stockData.data!.last.price),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              width: 210,
              height: 139,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}

class InvestCardPlaceholder extends StatelessWidget {
  const InvestCardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromRGBO(238, 238, 238, 0.75),
      highlightColor: Colors.white,
      child: Container(
        width: 210,
        height: 139,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
