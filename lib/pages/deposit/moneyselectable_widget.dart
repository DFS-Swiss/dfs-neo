import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/filter/valuefilter_widget.dart';

class MoneySelectable extends HookWidget {
  final Function callback;
  const MoneySelectable( {required this.callback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterValue = useState<String>("");
    final currentState = useState<int>(-1);
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
                currentState: currentState.value,
                id: 0,
                text: "\$100",
                value: "100",
                callback: (String a) {
                  if (filterValue.value == (a)) {
                    filterValue.value = "";
                    currentState.value = -1;
                  } else {
                    filterValue.value = a;
                    currentState.value = 0;
                  }
                  callback(filterValue.value);
                }),
            ValueFilter(
                currentState: currentState.value,
                id: 1,
                text: "\$200",
                value: "200",
                callback: (String a) {
                  if (filterValue.value == (a)) {
                    filterValue.value = "";
                    currentState.value = -1;
                  } else {
                    filterValue.value = a;
                    currentState.value = 1;
                  }
                  callback(filterValue.value);
                }),
            ValueFilter(
                currentState: currentState.value,
                id: 2,
                text: "\$500",
                value: "500",
                callback: (String a) {
                  if (filterValue.value == (a)) {
                    filterValue.value = "";
                    currentState.value = -1;
                  } else {
                    filterValue.value = a;
                    currentState.value = 2;
                  }
                  callback(filterValue.value);
                }),
            ValueFilter(
                currentState: currentState.value,
                id: 3,
                text: "\$1000",
                value: "1000",
                callback: (String a) {
                  if (filterValue.value == (a)) {
                    filterValue.value = "";
                    currentState.value = -1;
                  } else {
                    filterValue.value = a;
                    currentState.value = 3;
                  }
                  callback(filterValue.value);
                }),
          ],
        ),
      ),
    );
  }
}
