import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_available_stocks.dart';
import 'package:neo/pages/stocklist/stockfilter_widget.dart';
import 'package:neo/pages/stocklist/stocksearchbar_widget.dart';
import 'package:neo/pages/stocklist/stockswitchrow_widget.dart';
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
    final searchPattern = useState<String?>(null);
    useEffect(() {
      if (searchPattern.value == null) {
      } else {}
      return;
    }, [searchPattern.value]);
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
        addAutomaticKeepAlives: true,
        children: [
          StockSearchBar(callback: (String searchinput) {
            if (searchinput == "") {
              searchPattern.value = null;
            } else {
              searchPattern.value = searchinput;
            }
          }),
          StockSwitchRow(callback: (int i) {
            print("Current index: $i");
            switchPosition.value = i;
          }),
          StockFilter(
            init: selectedFilters.value,
            callback: (List<int> selectedFilter) {
              selectedFilters.value = [...selectedFilter];
            },
          ),
          searchPattern.value == null
              ? GenericHeadline(
                  title: AppLocalizations.of(context)!.list_featured,
                )
              : Container(),
          searchPattern.value == null
              ? SizedBox(
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
                        token: "dGME",
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                )
              : Container(),
          GenericHeadline(
            title: AppLocalizations.of(context)!.list_tradable,
          ),
          availableStocks.loading == false
              ? Column(
                  children: availableStocks.data!
                      .where((element) {
                        //TODO: Filter tiles depending on their type. This is currently just a workaround
                        if (selectedFilters.value.isEmpty) {
                          return true;
                        } else if (selectedFilters.value.contains(0)) {
                          return true;
                        } else {
                          return false;
                        }
                      })
                      .where((element) {
                        if (element.symbol.contains(
                                searchPattern.value ?? element.symbol) ||
                            element.displayName.contains(
                                searchPattern.value ?? element.displayName)) {
                          return true;
                        } else {
                          return false;
                        }
                      })
                      .map((e) => TradableStockCard(
                            token: e.symbol,
                            key: UniqueKey(),
                          ))
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
