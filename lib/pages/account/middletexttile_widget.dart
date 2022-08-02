import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MiddleTextTile extends HookWidget {
  final String text;
  final Function callback;
  const MiddleTextTile(this.text, this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTapped = useState<bool>(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor.withOpacity(0.25),
        ),
        onTapCancel: () {
          isTapped.value = false;
          callback();
        },
        onHighlightChanged: (a) {
          isTapped.value = a;
        },
        onTap: () {
          isTapped.value = false;
          callback();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).backgroundColor),
            color: Theme.of(context).backgroundColor.withOpacity(0.75),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text),
                Expanded(child: Container()),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
