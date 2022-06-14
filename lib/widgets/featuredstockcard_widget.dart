import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/utils/chart_conversion.dart';

class FeaturedStockCard extends HookWidget {
  final bool positiveDemo;
  const FeaturedStockCard({required this.positiveDemo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return positiveDemo
        ? Container(
            height: 139,
            width: 210,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Row for Icon; Symbol, Companyname, currentprice and growth in percent
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        //Image
                        SizedBox(
                          width: 38,
                          height: 38,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3-alpha-sig.figma.com/img/037a/ddc0/ad77a32e5b71f1740e21bba6619cb283?Expires=1656288000&Signature=YGcNLIdS4O7zqfvuXxUskIjN71PDseah-nwuPxMlUbxj2BfzYZLBQyoB5AhwWt2oUzQiWIfP2ffD2yme7H2rbrgDijlAAYIVnwRmsPxkXd4fJ0tL0-Tfj8PC--RbdNmCnJqh9j2zUQi8ZmyqVi6aqH7ffwalmVlXH4WBurPY9eJmP2RSjLeG1xuVnT4LastZfzG02VjByiVns524G2ydhFBup8EyK8bH598SgNeJLQSv0d9UOoo4Gz~39wHMYso~L~QWC7FS~J60Or0RHpUYzT2L9QqW-S1ueDHMO8DWVwyRpJ~FLN-7O-FFW4T~1tNJG1f~ZRMjdUA1qsPYZVZJnA__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA"),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        //Ticker and Companyname
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "AAPL",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "Apple Inc.",
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
                        Expanded(child: Container()),
                        //Current Value and growth in %
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "\$467.39",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "+ 17%",
                              style: TextStyle(
                                fontSize: 12,
                                color: NeoTheme.of(context)!.positiveColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //Stock Graph
                SizedBox(
                  height: 70,
                  //width: 100,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 15),
                    child: LineChart(preview([
                      FlSpot(0.0, 70),
                      FlSpot(1.0, 24),
                      FlSpot(2.0, 55),
                      FlSpot(3.0, 11),
                      FlSpot(5.0, 27),
                      FlSpot(6.0, 52),
                      FlSpot(7.0, 33),
                      FlSpot(8.0, 24),
                      FlSpot(9.0, 28),
                      FlSpot(10.0, 15),
                      FlSpot(11.0, 100),
                    ], false)),
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: 139,
            width: 210,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Row for Icon; Symbol, Companyname, currentprice and growth in percent
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        //Image
                        SizedBox(
                          width: 38,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3-alpha-sig.figma.com/img/c503/8a6e/aacd76305bbd59ea7366fa763deb44e2?Expires=1656288000&Signature=RULTfC5-T9kl5wTG6AMW4D1GCa23pHZuDdni8VfKPjboMtZObRSQeswWD6J2ZeWMNOuAAyjo526l4HtXHpsg~PmhU8gaFPDx4J15xMXH3GtaJKe1xvbRDtJnvPum6XDWBmq~Yca-xZB1teHe72oBKLYLVggv9POYSfeZQpoibueqBxpcetBZM0YBXGCF3wGrq9Nf2al49B6Vg3xZ8bZy9ByAwmOparS1ZpOERAWmPuvLE3HH2d8K-Dk8ulQSsfNv6JEfJdpMZPhZfD-LnvoV-Kf8LAK5SqSdGZXA8KXzNUlTSld5E8KA6d~pw5~qUer9DnG3NNfkKJgjgoBPuiZ4Zw__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA"),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        //Ticker and Companyname
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "AMZN",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "Amazon",
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
                        Expanded(child: Container()),
                        //Current Value and growth in %
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "\$241.56",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "- 4%",
                              style: TextStyle(
                                fontSize: 12,
                                color: NeoTheme.of(context)!.negativeColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //Stock Graph
                SizedBox(
                  height: 70,
                  //width: 100,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 15),
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
              ],
            ),
          );
  }
}
