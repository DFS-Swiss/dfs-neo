import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SortingWidget extends HookWidget {
  final String titel;
  final Function callback;
  final int status;
  final bool enableGrowthFilter;
  const SortingWidget(
      {required this.status,
      required this.titel,
      required this.enableGrowthFilter,
      required this.callback,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentStatus = useState(status);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titel,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              switch (currentStatus.value) {
                case 0:
                  currentStatus.value = 1;
                  break;
                case 1:
                  currentStatus.value = 2;
                  break;
                case 2:
                  currentStatus.value = 0;
                  break;
                  case 3:
                  currentStatus.value = 1;
                  break;
                  case 4:
                  currentStatus.value = 1;
                  break;
              }
              callback(currentStatus.value);
            },
            child: currentStatus.value == 0 || currentStatus.value >= 3
                ? Row(
                    children: [
                      Icon(Icons.arrow_upward),
                      Text("A-Z"),
                    ],
                  )
                : currentStatus.value == 1
                    ? Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            "A-Z",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            "A-Z",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
          ),
          SizedBox(
            width: 5,
          ),
          enableGrowthFilter
              ? GestureDetector(
                  onTap: () {
                    switch (currentStatus.value) {
                      case 0:
                        currentStatus.value = 4;
                        break;
                        case 1:
                        currentStatus.value = 4;
                        break;
                        case 2:
                        currentStatus.value = 4;
                        break;
                        case 3:
                        currentStatus.value = 4;
                        break;
                      case 4:
                        currentStatus.value = 5;
                        break;
                      case 5:
                        currentStatus.value = 3;
                        break;
                    }
                    callback(currentStatus.value);
                  },
                  child: currentStatus.value < 4
                      ? Row(
                          children: [
                            Icon(Icons.arrow_upward),
                            Icon(Icons.sort),
                          ],
                        )
                      : currentStatus.value == 4
                          ? Row(
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Icon(
                                  Icons.sort,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Icon(
                                  Icons.sort,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                )
              : Container(),
        ],
      ),
    );
  }
}
