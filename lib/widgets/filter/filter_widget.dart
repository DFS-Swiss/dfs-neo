import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_brightness.dart';
import 'package:neo/style/theme.dart';

class Filter extends HookWidget {
  final bool initChecked;
  final String text;
  final int id;
  final Function callback;
  const Filter(
      {required this.initChecked,
      required this.id,
      required this.text,
      required this.callback,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final brightness = useBrightness();
    final initCheck = useState(initChecked);
    final selected = useState<bool>(false);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          selected.value = !selected.value;
          initCheck.value = !initCheck.value;
          callback(id);
        },
        child: Container(
          alignment: Alignment.center,
          height: 32,
          width: 84,
          decoration: selected.value || initCheck.value
              ? BoxDecoration(
                  gradient: NeoTheme.of(context)!.primaryGradient,
                  borderRadius: BorderRadius.circular(12))
              : BoxDecoration(
                  color: Theme.of(context).backgroundColor.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
          child: Text(
            text,
            style: TextStyle(
                color: selected.value ||
                        initCheck.value ||
                        brightness ==
                            Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}
