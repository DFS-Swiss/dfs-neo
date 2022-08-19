import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_brightness.dart';
import 'package:neo/style/theme.dart';

class SmallValueFilter extends HookWidget {
  final String text;
  final Object value;
  final Object currentValue;
  final Function callback;
  const SmallValueFilter(
      {required this.currentValue,
      required this.text,
      required this.value,
      required this.callback,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final brightness = useBrightness();
    final selected = useState<bool>(false);
    selected.value = currentValue == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          selected.value = !selected.value;
          callback(value);
        },
        child: Container(
          alignment: Alignment.center,
          height: 32,
          width: 44,
          decoration: selected.value && currentValue == value
              ? BoxDecoration(
                  gradient: NeoTheme.of(context)!.primaryGradient,
                  borderRadius: BorderRadius.circular(12))
              : BoxDecoration(
                  color: Theme.of(context).backgroundColor.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 1, color: Colors.white.withOpacity(0.25)),
                ),
          child: Text(
            text,
            style: TextStyle(
                color: (selected.value && currentValue == value) ||
                        brightness ==
                            Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12),
          ),
        ),
      ),
    );
  }
}
