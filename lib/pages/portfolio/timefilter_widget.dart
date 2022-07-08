import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/stocklist/singlestockfilter_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeFilter extends HookWidget {
  final Function callback;
  final int init;
  const TimeFilter({required this.init, required this.callback, Key? key})
      : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    final filterOptions = useState<int>(init);
     bool checkInit(int id) {
    if (filterOptions.value == id) return true;
    return false;
  }
    
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
                initChecked: checkInit(0),
                id: 0,
                text: AppLocalizations.of(context)!.list_toggle_stocks,
                callback: (int a) {
                  filterOptions.value = a;
                }),
            SingleStockFilter(
                initChecked: checkInit(1),
                id: 1,
                text: AppLocalizations.of(context)!.list_toggle_etc,
                callback: (int a) {
                  filterOptions.value = a;
                }),
            SingleStockFilter(
                initChecked: checkInit(2),
                id: 2,
                text: AppLocalizations.of(context)!.list_toggle_etf,
                callback: (int a) {
                 filterOptions.value = a;
                }),
          ],
        ),
      ),
    );
  }
}
