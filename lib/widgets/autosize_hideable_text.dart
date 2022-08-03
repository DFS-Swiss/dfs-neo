import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_balance_hidden.dart';

class AutoSizeHideableText extends HookWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  const AutoSizeHideableText(this.text, {Key? key, this.style, required this.maxLines})
      : super(key: key);

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

    return AutoSizeText(
      hideBalance ? makeHiddenText() : text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: style,
    );
  }
}
