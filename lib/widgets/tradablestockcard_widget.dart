import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/utils/chart_conversion.dart';

class TradableStockCard extends HookWidget {
  final bool positiveDemo;
  const TradableStockCard({required this.positiveDemo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return positiveDemo
        ? Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Container(
              height: 74,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //Companyimage
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://s3-alpha-sig.figma.com/img/57dc/ef81/070c24e7d5614e6ae7be5bb30373340a?Expires=1656288000&Signature=Jq9ch2TBnNP6A84x9WGQj2YzHVPlPxWR45AXFJDBf1uePCRGtKKRuHRvydfu8BRHPsed~QvkiI6lZy-U2ooJPqxpO-u-L1~yEqCNBMf9pvZrxstGqfIffA7611TAGkqevIypO8E9SIEykkG-cjq82XG1HeBiOxXG0TIlgZ3asL56-acTgPTGin49w2Vd-nWoXSfQ9t2~v3veyIVm1nmh2t9F~iB4jwv7~Nem2AwhqyB914VE~ydbvcCvaHlGN0lFgAdGGJt2xG4xEED4wkR27mnHNvKS~M0-1mAFqFM8hDDP48GsLnzO1PsZ8d0DVhJRnzKUJXmHaH75HDWuNT91sQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA"),
                      ),
                    ),
                  ),
                  //Ticker and Companyname
                  SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "NVDA",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(child: Container()),
                        Text(
                          "NVIDIA",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF909090),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(),
                  ),
                  //Graph
                  SizedBox(
                    //height: 100,
                    width: 96,
                    //width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 24, bottom: 24),
                      child: LineChart(preview([
                        FlSpot(0.0, 70),
                        FlSpot(1.0, 24),
                        FlSpot(2.0, 55),
                        FlSpot(3.0, 11),
                        FlSpot(5.0, 27),
                        FlSpot(6.0, 52),
                        FlSpot(7.0, 33),
                        FlSpot(8.0, 24),
                        FlSpot(9.0, 85),
                        FlSpot(10.0, 45),
                        FlSpot(11.0, 74),
                      ], false)),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(),
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "\$467.39",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(child: Container()),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_up_outlined,
                                size: 25,
                                color: NeoTheme.of(context)!.positiveColor,
                              ),
                              Text(
                                "17%",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: NeoTheme.of(context)!.positiveColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
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
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Container(
              height: 74,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //Companyimage
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://s3-alpha-sig.figma.com/img/faa6/b9f1/0fb73b5ed3f2848be0490a7839103080?Expires=1656288000&Signature=dzqTcfAwTJnntavrKFubG3n-qLddBxwS0FxoNxlccuWKBcqWO4S3VVIPVCr8GGMoRC4LUWL5Og8ruRqgQD6nqRMTNuHK4Jg5~GkuTRh3GMUal6oZnP8YXeZ9aSAVl9N49UKwfBEx~fVYugO~MEpseL4kGxlwc3xrVl0eSJNqGsG1ScPWerck4H8dLAa7qEalqTfwjbNwxImsBmkqtWIlIDD0ZPY6qSW88cVW801RBsPv1fhHoleDljrDWLM6izulC-siKwIByA3iCLw4ujOEMvADnXBnYbu5m2eqlbZAhLtNaZOQ6QqXSj~Y00at1S37l0D4JeKQ9qDK0-Q6nJ2ZFQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA"),
                      ),
                    ),
                  ),
                  //Ticker and Companyname
                  SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "WMT",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(child: Container()),
                        Text(
                          "Walmart",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF909090),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(),
                  ),
                  //Graph
                  SizedBox(
                    //height: 100,
                    width: 96,
                    //width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 24, bottom: 24),
                      child: LineChart(preview([
                        FlSpot(0.0, 70),
                        FlSpot(1.0, 24),
                        FlSpot(2.0, 55),
                        FlSpot(3.0, 65),
                        FlSpot(5.0, 85),
                        FlSpot(6.0, 52),
                        FlSpot(7.0, 33),
                        FlSpot(8.0, 24),
                        FlSpot(9.0, 28),
                        FlSpot(10.0, 15),
                        FlSpot(11.0, 17),
                      ], true)),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(),
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "\$1,436.39",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(child: Container()),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 25,
                                color: NeoTheme.of(context)!.negativeColor,
                              ),
                              Text(
                                "45%",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: NeoTheme.of(context)!.negativeColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
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
            ),
          );
  }
}
