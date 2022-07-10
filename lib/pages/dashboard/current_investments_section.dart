import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_userassets.dart';

import '../../style/theme.dart';
import '../../widgets/cards/investment_card.dart';

class CurrentInvestmentsSection extends HookWidget {
  const CurrentInvestmentsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assests = useUserassets();

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.dash_currinv_title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                AppLocalizations.of(context)!.dash_view,
                style: NeoTheme.of(context)!.linkTextStyle,
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 140,
            child: assests.loading
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      InvestCardPlaceholder(),
                      SizedBox(
                        width: 16,
                      ),
                      InvestCardPlaceholder(),
                      SizedBox(
                        width: 16,
                      ),
                      InvestCardPlaceholder(),
                    ],
                  )
                : assests.data!.isEmpty
                    ? Center(
                        child:
                            Text(AppLocalizations.of(context)!.dashboard_no_investments),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InvestmentCard(
                          key: ValueKey(assests.data![index].symbol),
                          token: assests.data![index].symbol,
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16),
                        itemCount: assests.data!.length,
                      ),
          )
        ],
      ),
    );
  }
}
