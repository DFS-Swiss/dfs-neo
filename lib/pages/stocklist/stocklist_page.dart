import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_available_stocks.dart';
import 'package:neo/hooks/use_userassets.dart';
import 'package:neo/pages/details/details_page.dart';
import 'package:neo/pages/stocklist/stockfilter_widget.dart';
import 'package:neo/pages/stocklist/stocksearchbar_widget.dart';
import 'package:neo/utils/display_popup.dart';
import 'package:neo/widgets/switchrow_widget.dart';
import 'package:neo/widgets/appbaractionbutton_widget.dart';
import 'package:neo/widgets/cards/dynamic_shimmer_cards.dart';
import 'package:neo/widgets/cards/featuredstockcard_widget.dart';
import 'package:neo/widgets/genericheadline_widget.dart';
import 'package:neo/widgets/cards/tradablestockcard_widget.dart';




class StockList extends HookWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final switchPosition = useState<int>(0);
    final selectedFilters = useState<List<int>>([]);
    final availableStocks = useAvailableStocks();
    final searchPattern = useState<String?>(null);
    final userAssets = useUserassets();
    useEffect(() {
      if (searchPattern.value == null) {
      } else {}
      return;
    }, [searchPattern.value]);
    useEffect(() {
      if (!userAssets.loading) {
      } else {}
      return;
    }, [userAssets.loading]);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.list_title),
        actions: [
          AppBarActionButton(
            icon: Icons.notifications_none,
            callback: () {
              displayInfoPage(context);
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
          SwitchRow(
            options: [
              SwitchRowItem<int>(
                selected: switchPosition.value == 0,
                callback: (v) => switchPosition.value = v,
                value: 0,
                text: AppLocalizations.of(context)!.list_switch_all,
              ),
              SwitchRowItem<int>(
                selected: switchPosition.value == 1,
                callback: (v) => switchPosition.value = v,
                value: 1,
                text: AppLocalizations.of(context)!.list_switch_my,
              ),
              SwitchRowItem<int>(
                selected: switchPosition.value == 2,
                callback: (v) => switchPosition.value = v,
                value: 2,
                text: AppLocalizations.of(context)!.list_switch_fav,
              ),
            ],
          ),
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
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailsPage(
                                token: "dAAPL",
                                key: UniqueKey(),
                              ),
                            ),
                          );
                        },
                        child: FeaturedStockCard(
                          token: "dAAPL",
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailsPage(
                                token: "dBABA",
                                key: UniqueKey(),
                              ),
                            ),
                          );
                        },
                        child: FeaturedStockCard(
                          token: "dBABA",
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailsPage(
                                token: "dPLTR",
                                key: UniqueKey(),
                              ),
                            ),
                          );
                        },
                        child: FeaturedStockCard(
                          token: "dPLTR",
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                )
              : Container(),
          GenericHeadline(
            title: switchPosition.value == 1
                ? AppLocalizations.of(context)!.list_mystocks
                : AppLocalizations.of(context)!.list_tradable,
          ),
          availableStocks.loading == false
              ? Column(
                  children: availableStocks.data!
                      .where((element) {
                        //TODO: Filter tiles depending on their type. This is currently just a workaround
                        if (selectedFilters.value.isEmpty) {
                          return true;
                        } else if (selectedFilters.value.contains(0) && element.assetType == "stock" || selectedFilters.value.contains(1) && element.assetType == "trust" || selectedFilters.value.contains(2) && element.assetType == "etf") {
                          return true;
                        } else {
                          return false;
                        }
                      })
                      .where((element) {
                        if (switchPosition.value == 1 && !userAssets.loading) {
                          for (var asset in userAssets.data!.toList()) {
                            if (asset.symbol == element.symbol) {
                              return true;
                            }
                          }
                          return false;
                        } else {
                          return true;
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
                      .map(
                        (e) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailsPage(
                                    token: e.symbol,
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            },
                            child: TradableStockCard(
                              token: e.symbol,
                              key: UniqueKey(),
                            )),
                      )
                      .toList(),
                )
              : DynamicShimmerCards(cardAmount: 3, cardHeight: 74, bottomPadding: 16, sidePadding: 20)
        ],
      ),
    );
  }
}
