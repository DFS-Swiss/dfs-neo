import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/style/theme.dart';

class ValueFilter extends HookWidget {
  final String text;
  final String value;
  final int id;
  final int currentState;
  final Function callback;
  const ValueFilter(
      {required this.currentState,
      required this.id,
      required this.text,
      required this.value,
      required this.callback,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final selected = useState<bool>(false);
    if(currentState != id){
      selected.value = false;
    }
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
          width: 84,
          decoration: selected.value && currentState == id
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
                    selected.value && currentState == id ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}
