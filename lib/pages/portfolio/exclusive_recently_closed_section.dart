import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_userassets_history.dart';

import 'package:neo/pages/recently_closed_investments_page/recently_closed_investment_page.dart';

import '../../style/theme.dart';
import '../../widgets/cards/recently_closed_order_card.dart';
import 'package:neo/utils/lists.dart';

class ExclusiveRecentlyClosedSection extends HookWidget {
  final String exclusiveSymbol;
  const ExclusiveRecentlyClosedSection(
      {required this.exclusiveSymbol, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investmenthistory = useUserassetsHistory();



    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.dash_rec_title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecentlyClosedInvestments(
                                  exclusiveSymbol: exclusiveSymbol,
                                  key: key,
                                )));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.dash_view,
                    style: NeoTheme.of(context)!.linkTextStyle,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: !investmenthistory.loading
                  ? investmenthistory.data!.inlineSort((a,b) => b.time.compareTo(a.time)).where((element) => element.symbol == exclusiveSymbol)
                      .take(3)
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: RecentlyClosedOrderCard(
                                data: e,
                                key: Key("details${e.symbol}${e.time}")),
                          ))
                      .toList()
                  : [
                      Container(),
                    ],
            ),
          )
        ],
      ),
    );
  }
}
