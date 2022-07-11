import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/filter/valuefilter_widget.dart';

import '../../types/stockdata_interval_enum.dart';
import '../../widgets/filter/small_value_filter.dart';

class DetailsSelectable extends HookWidget {
  final Function callback;
  final StockdataInterval currentValue;
  const DetailsSelectable(
      {required this.callback, required this.currentValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: SizedBox(
        height: 32,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: 24,
            ),
            SmallValueFilter(
                currentValue: currentValue,
                text: "24h",
                value: StockdataInterval.twentyFourHours,
                callback: (Object a) {
                  callback(a);
                }),
            SmallValueFilter(
                currentValue: currentValue,
                text: "MTD",
                value: StockdataInterval.mtd,
                callback: (Object a) {
                  callback(a);
                }),
            SmallValueFilter(
                currentValue: currentValue,
                text: "YTD",
                value: StockdataInterval.ytd,
                callback: (Object a) {
                  callback(a);
                }),
            SmallValueFilter(
                currentValue: currentValue,
                text: "1Y",
                value: StockdataInterval.oneYear,
                callback: (Object a) {
                  callback(a);
                }),
            SmallValueFilter(
                currentValue: currentValue,
                text: "2Y",
                value: StockdataInterval.twoYears,
                callback: (Object a) {
                  callback(a);
                }),
          ],
        ),
      ),
    );
  }
}
