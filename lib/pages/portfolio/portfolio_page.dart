import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/dashboard/portfolio_balance_card.dart';
import 'package:neo/pages/portfolio/best_worst_card_widget.dart';
import 'package:neo/pages/portfolio/difference_card_widget.dart';
import 'package:neo/pages/portfolio/timefilter_widget.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/widgets/appbaractionbutton_widget.dart';
import 'package:neo/widgets/buttons/branded_button.dart';
import 'package:neo/widgets/buttons/outline_button.dart';
import 'package:neo/widgets/genericheadline_widget.dart';

import 'distribution_widget.dart';

class Portfolio extends HookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFilter = useState<int>(0);
    final interval =
        useState<StockdataInterval>(StockdataInterval.twentyFourHours);

    useEffect(() {
      switch (timeFilter.value) {
        case 0:
          interval.value = StockdataInterval.twentyFourHours;
          break;
        case 1:
          interval.value = StockdataInterval.mtd;
          break;
        case 2:
          interval.value = StockdataInterval.ytd;
          break;
        case 3:
          interval.value = StockdataInterval.oneYear;
          break;
        case 4:
          interval.value = StockdataInterval.twoYears;
          break;
        default:
      }
      return;
    }, [timeFilter.value]);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.port_title),
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
          TimeFilter(
              init: timeFilter.value,
              callback: (int a) {
                timeFilter.value = a;
              }),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: PortfolioBalanceCard(
              interval: interval.value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlineBrandedButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.port_withdraw,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: BrandedButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.port_deposit,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ),
          GenericHeadline(
            title: AppLocalizations.of(context)!.port_overview_title,
          ),
          DifferenceCard(interval: interval.value),
          SizedBox(
            height: 28,
          ),
          BestWorstCard(interval: interval.value),
          GenericHeadline(
            title: AppLocalizations.of(context)!.port_allocation_title,
          ),
          DistributionWidget(),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
