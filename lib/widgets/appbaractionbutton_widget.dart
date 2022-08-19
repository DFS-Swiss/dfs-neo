import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_brightness.dart';

class AppBarActionButton extends HookWidget {
  final IconData icon;
  final Function callback;
  const AppBarActionButton(
      {required this.icon, required this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = useBrightness();
    final isTapped = useState<bool>(false);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 24),
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
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white.withOpacity(0.25),
            ),
            color: brightness == Brightness.dark
                ? Theme.of(context).backgroundColor
                : Theme.of(context).backgroundColor.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isTapped.value ||
                    brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
