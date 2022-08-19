import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_available_stocks.dart';
import 'package:neo/pages/stocklist/stockfilter_widget.dart';
import 'package:neo/pages/stocklist/stocklist_sorting_widget.dart';
import 'package:neo/utils/lists.dart';
import 'package:neo/widgets/cards/dynamic_shimmer_cards.dart';

import '../../hooks/use_userassets.dart';
import '../../service_locator.dart';
import '../../services/analytics_service.dart';
import '../../widgets/cards/investment_card.dart';
import '../details/details_page.dart';

class CurrentInvestmentPage extends HookWidget {
  const CurrentInvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedFilters = useState<List<int>>([]);
    final assests = useUserassets();
    final sortState = useState<int>(
        0); //1 Aufsteigend Name; 2 Absteigend Name; 3 Aufsteigend 24h Entwicklung; 4. Absteigend 24h Entwicklung
    final availableStocks = useAvailableStocks();
    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:current_investments");
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.dash_currinv_title),
      ),
      body: ListView(
        children: [
          StockFilter(
            init: selectedFilters.value,
            callback: (List<int> selectedFilter) {
              selectedFilters.value = [...selectedFilter];
            },
          ),
          SortingWidget(
              titel: AppLocalizations.of(context)!.list_mystocks,
              status: sortState.value,
              callback: (int a) {
                sortState.value = a;
              }),
          availableStocks.loading == false
              ? Column(
                  children: assests.data!
                      .where((asset) {
                        if (selectedFilters.value.isEmpty) {
                          return true;
                        } else if (selectedFilters.value.contains(0) &&
                                availableStocks.data!
                                        .where((element) =>
                                            element.symbol == asset.symbol)
                                        .first
                                        .assetType ==
                                    "stock" ||
                            availableStocks.data!
                                    .where((element) =>
                                        element.symbol == asset.symbol)
                                    .first
                                    .assetType ==
                                "trust" ||
                            availableStocks.data!
                                    .where((element) =>
                                        element.symbol == asset.symbol)
                                    .first
                                    .assetType ==
                                "etf") {
                          return true;
                        } else {
                          return false;
                        }
                      })
                      .toList()
                      .userAssetlistSort(sortState.value)
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: GestureDetector(
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
                            child: InvestmentCard(
                              expandHorizontal: true,
                              token: e.symbol,
                              key: ValueKey(e.symbol),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              : DynamicShimmerCards(
                  cardAmount: 3,
                  cardHeight: 74,
                  bottomPadding: 16,
                  sidePadding: 20)
        ],
      ),
    );
  }
}
