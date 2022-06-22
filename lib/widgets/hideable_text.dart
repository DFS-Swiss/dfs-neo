import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_balance_hidden.dart';

class HideableText extends HookWidget {
  final String text;
  final TextStyle? style;
  const HideableText(
    this.text, {
    Key? key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hideBalance = useBalanceHidden();

    String makeHiddenText() {
      String out = "****";
      for (var i = 0; i < (text.length - 4).clamp(0, 10); i++) {
        out += "*";
      }
      return out;
    }

    return Text(
      hideBalance ? makeHiddenText() : text,
      style: style,
    );
  }
}
