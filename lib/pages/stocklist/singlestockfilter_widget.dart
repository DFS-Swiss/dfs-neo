import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class SingleStockFilter extends HookWidget {
  final String text;
  final int id;
  final Function callback;
  const SingleStockFilter(
      {required this.id, required this.text, required this.callback, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final selected = useState<bool>(false);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          selected.value = !selected.value;
          callback(id);
        },
        child: Container(
          alignment: Alignment.center,
          height: 32,
          width: 84,
          decoration: BoxDecoration(
              color: !selected.value
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            text,
            style: TextStyle(
                color: selected.value ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}
