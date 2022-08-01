import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../hooks/use_userassets.dart';
import '../../service_locator.dart';
import '../../services/analytics_service.dart';
import '../../widgets/cards/investment_card.dart';
import '../details/details_page.dart';

class CurrentInvestmentPage extends HookWidget {
  const CurrentInvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assests = useUserassets();

    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:current_investments");
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.dash_currinv_title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
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
            child: InvestmentCard(
              key: ValueKey(assests.data![index].symbol),
              token: assests.data![index].symbol,
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemCount: assests.data!.length,
        ),
      ),
    );
  }
}
