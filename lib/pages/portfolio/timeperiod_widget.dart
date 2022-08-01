import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/style/theme.dart';

class TimePeriod extends HookWidget {
  final String text;
  final int id;
  final Function callback;
  final int currentlySelected;
  final bool enabled;
  const TimePeriod(
      {required this.currentlySelected,
      required this.id,
      required this.text,
      required this.callback,
      required this.enabled,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final selected = useState<bool>(false);
    if (id == currentlySelected) {
      selected.value = true;
    } else {
      selected.value = false;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: enabled
            ? () {
                callback(id);
              }
            : null,
        child: Container(
          alignment: Alignment.center,
          height: 32,
          //width: 84,
          decoration: selected.value
              ? BoxDecoration(
                  gradient: NeoTheme.of(context)!.primaryGradient,
                  borderRadius: BorderRadius.circular(12))
              : BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: Colors.white),
                ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text,
              style: TextStyle(
                  color: selected.value ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
