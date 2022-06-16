import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/stocklist/singlestockfilter_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StockFilter extends HookWidget {
  final Function callback;
  final List<int> init;
  const StockFilter( {required this.init,required this.callback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterOptions = useState<List<int>>(init);
    return Padding(
      padding: const EdgeInsets.only(
        top: 26,
      ),
      child: SizedBox(
        height: 32,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: 24,
            ),
            SingleStockFilter(
                initChecked: filterOptions.value.contains(0),
                id: 0,
                text: AppLocalizations.of(context)!.list_toggle_stocks,
                callback: (int a) {
                  if (filterOptions.value.contains(a)) {
                    filterOptions.value.remove(a);
                  } else {
                    filterOptions.value.add(a);
                  }
                  callback(filterOptions.value);
                }),
            SingleStockFilter(
                initChecked: filterOptions.value.contains(1),
                id: 1,
                text: AppLocalizations.of(context)!.list_toggle_etc,
                callback: (int a) {
                  if (filterOptions.value.contains(a)) {
                    filterOptions.value.remove(a);
                  } else {
                    filterOptions.value.add(a);
                  }
                  callback(filterOptions.value);
                }),
            SingleStockFilter(
                initChecked: filterOptions.value.contains(2),
                id: 2,
                text: AppLocalizations.of(context)!.list_toggle_etf,
                callback: (int a) {
                  if (filterOptions.value.contains(a)) {
                    filterOptions.value.remove(a);
                  } else {
                    filterOptions.value.add(a);
                  }
                  callback(filterOptions.value);
                }),
          ],
        ),
      ),
    );
  }
}
