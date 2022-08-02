import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextTile extends HookWidget {
  final String text;
  final Function callback;
  const TextTile({required this.text, required this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTapped = useState<bool>(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).backgroundColor.withOpacity(0.75),
              border: Border.all(color: Theme.of(context).backgroundColor)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                ),
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
