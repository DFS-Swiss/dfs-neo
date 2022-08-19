import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/theme_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/widgets/filter/valuefilter_widget.dart';

class BrightnessSelectable extends HookWidget {
  final Function callback;
  final ThemeState currentValue;
  const BrightnessSelectable(
      {required this.callback, required this.currentValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).backgroundColor.withOpacity(0.75),
            border: Border.all(color: Theme.of(context).backgroundColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueFilter(
                    currentValue: currentValue,
                    text: AppLocalizations.of(context)!.settings_theme_system,
                    value: ThemeState.system,
                    callback: (ThemeState a) {
                      callback(a);
                    }),
                ValueFilter(
                    currentValue: currentValue,
                    text: AppLocalizations.of(context)!.settings_theme_light,
                    value: ThemeState.light,
                    callback: (ThemeState a) {
                      callback(a);
                    }),
                ValueFilter(
                    currentValue: currentValue,
                    text: AppLocalizations.of(context)!.settings_theme_dark,
                    value: ThemeState.dark,
                    callback: (ThemeState a) {
                      callback(a);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
