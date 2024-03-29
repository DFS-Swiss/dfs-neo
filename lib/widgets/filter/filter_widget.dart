import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
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
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: Colors.white),
                ),
          child: Text(
            text,
            style: TextStyle(
                color:
                    selected.value || initCheck.value ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}
