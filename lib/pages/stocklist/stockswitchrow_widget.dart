import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/widgets/buttons/branded_button.dart';

class StockSwitchRow extends HookWidget {
  final Function callback;
  final int initPos;
  const StockSwitchRow({required this.initPos, required this.callback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final switchPosition = useState(initPos);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: switchPosition.value == 0
                    ? BrandedButton(
                        onPressed: () {},
                        child:
                            Text(AppLocalizations.of(context)!.list_switch_all))
                    : TextButton(
                        onPressed: () {
                          switchPosition.value = 0;
                          callback(switchPosition.value);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.list_switch_all)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: switchPosition.value == 1
                    ? BrandedButton(
                        onPressed: () {},
                        child:
                            Text(AppLocalizations.of(context)!.list_switch_my))
                    : TextButton(
                        onPressed: () {
                          switchPosition.value = 1;
                          callback(switchPosition.value);
                        },
                        child:
                            Text(AppLocalizations.of(context)!.list_switch_my)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: switchPosition.value == 2
                    ? BrandedButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.list_switch_fav,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          switchPosition.value = 2;
                          callback(switchPosition.value);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.list_switch_fav)),
              ),
            ),
            SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }
}
