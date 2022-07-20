import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BottomTextTile extends HookWidget {
  final String text;
  final Function callback;
  const BottomTextTile(this.text, this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTapped = useState<bool>(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
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
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12)),
            border: Border.all(color: Colors.white),
            color: Colors.white.withOpacity(0.75),
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
