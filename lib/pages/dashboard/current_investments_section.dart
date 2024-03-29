import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_userassets.dart';

import '../../style/theme.dart';
import '../../widgets/cards/investment_card.dart';
import '../current_investments/current_investment_page.dart';
import '../details/details_page.dart';

class CurrentInvestmentsSection extends HookWidget {
  const CurrentInvestmentsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assests = useUserassets();

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
                  AppLocalizations.of(context)!.dash_currinv_title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                !assests.loading && assests.data!.isNotEmpty
                    ? GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CurrentInvestmentPage()),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.dash_view,
                          style: NeoTheme.of(context)!.linkTextStyle,
                        ),
                      )
                    : Container()
              ],
            ),
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
                      SizedBox(
                        width: 20,
                      ),
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
                        child: Text(AppLocalizations.of(context)!
                            .dashboard_no_investments),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => DetailsPage(
                                  token: assests.data![index].symbol,
                                  key: UniqueKey(),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: InvestmentCard(
                              key: ValueKey(assests.data![index].symbol),
                              token: assests.data![index].symbol,
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 0),
                        itemCount: assests.data!.length,
                      ),
          )
        ],
      ),
    );
  }
}
