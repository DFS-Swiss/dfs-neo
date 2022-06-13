import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/stocklist/stockfilter_widget.dart';
import 'package:neo/pages/stocklist/stocksearchbar_widget.dart';
import 'package:neo/pages/stocklist/stockswitchrow_widget.dart';

class StockList extends HookWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final switchPosition = useState(0);
    final selectedFilters = useState<List<int>>([]);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.list_title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              color: Colors.black,
              onPressed: () {
                //TODO: Add Route to Notification Screen
              },
              icon: Icon(Icons.notifications_none),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          StockSearchBar(),
          StockSwitchRow(callback: (int i) {
            print("Current index: $i");
            switchPosition.value = i;
          }),
          StockFilter(
            callback: (List<int> selectedFilter) {
              selectedFilters.value = selectedFilter;
              print(selectedFilters.value);
            },
          ),
        ],
      ),
    );
  }
}
