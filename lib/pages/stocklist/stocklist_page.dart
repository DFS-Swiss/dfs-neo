import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_available_stocks.dart';
import 'package:neo/hooks/use_stockdata.dart';
import 'package:neo/pages/stocklist/stockfilter_widget.dart';
import 'package:neo/pages/stocklist/stocksearchbar_widget.dart';
import 'package:neo/pages/stocklist/stockswitchrow_widget.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/widgets/appbaractionbutton_widget.dart';
import 'package:neo/widgets/featuredstockcard_widget.dart';
import 'package:neo/widgets/genericheadline_widget.dart';
import 'package:neo/widgets/tradablestockcard_widget.dart';
import 'package:shimmer/shimmer.dart';

class StockList extends HookWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final switchPosition = useState(0);
    final selectedFilters = useState<List<int>>([]);
    final availableStocks = useAvailableStocks();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.list_title),
        actions: [
          AppBarActionButton(
            icon: Icons.notifications_none,
            callback: () {
              print("Tapped notifications");
            },
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
          GenericHeadline(
            title: AppLocalizations.of(context)!.list_featured,
          ),
          SizedBox(
            height: 139,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SizedBox(
                  width: 24,
                ),
                FeaturedStockCard(
                  token: "dAAPL",
                ),
                SizedBox(
                  width: 16,
                ),
                FeaturedStockCard(
                  token: "dAAPL",
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          GenericHeadline(
            title: AppLocalizations.of(context)!.list_tradable,
          ),
          availableStocks.loading == false
              ? Column(
                  children: availableStocks.data!
                      .map((e) => TradableStockCard(token: e.symbol))
                      .toList(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      child: Shimmer.fromColors(
                        baseColor: Color.fromRGBO(238, 238, 238, 0.75),
                        highlightColor: Colors.white,
                        child: Container(
                          height: 74,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      child: Shimmer.fromColors(
                        baseColor: Color.fromRGBO(238, 238, 238, 0.75),
                        highlightColor: Colors.white,
                        child: Container(
                          height: 74,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      child: Shimmer.fromColors(
                        baseColor: Color.fromRGBO(238, 238, 238, 0.75),
                        highlightColor: Colors.white,
                        child: Container(
                          height: 74,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
