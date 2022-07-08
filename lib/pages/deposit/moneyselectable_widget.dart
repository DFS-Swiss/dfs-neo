import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/filter/valuefilter_widget.dart';

class MoneySelectable extends HookWidget {
  final Function callback;
  final String currentValue;
  const MoneySelectable( {required this.callback, required this.currentValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 26,
      ),
      child: SizedBox(
        height: 32,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: 24,
            ),
            ValueFilter(
                currentValue: currentValue,
                text: "\$100",
                value: "100",
                callback: (String a) {
                  callback(a);
                }),
            ValueFilter(
                currentValue: currentValue,
                text: "\$200",
                value: "200",
                callback: (String a) {
                  callback(a);
                }),
            ValueFilter(
                currentValue: currentValue,
                text: "\$500",
                value: "500",
                callback: (String a) {
                  callback(a);
                }),
            ValueFilter(
                currentValue: currentValue,
                text: "\$1000",
                value: "1000",
                callback: (String a) {
                  callback(a);
                }),
          ],
        ),
      ),
    );
  }
}
