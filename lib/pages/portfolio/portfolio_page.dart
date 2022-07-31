import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/current_investments/current_investment_page.dart';
import 'package:neo/pages/dashboard/portfolio_balance_card.dart';
import 'package:neo/pages/dashboard/recently_closed_section.dart';
import 'package:neo/pages/deposit/deposit_page.dart';
import 'package:neo/pages/portfolio/best_worst_card_widget.dart';
import 'package:neo/pages/portfolio/difference_card_widget.dart';

import 'package:neo/pages/portfolio/timefilter_widget.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/display_popup.dart';
import 'package:neo/widgets/appbaractionbutton_widget.dart';
import 'package:neo/widgets/buttons/branded_button.dart';
import 'package:neo/widgets/cards/portfolio_performance_card.dart';
import 'package:neo/widgets/genericheadline_widget.dart';
import 'package:neo/widgets/switchrow_widget.dart';

import '../../service_locator.dart';
import '../../services/analytics_service.dart';
import '../../enums/portfolio_development_mode.dart';

import '../../widgets/buttons/branded_outline_button.dart';
import '../information/feature_not_implemented_page.dart';
import 'current_investments_widget.dart';
import 'distribution_widget.dart';

class Portfolio extends HookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFilter = useState<int>(0);
    final interval =
        useState<StockdataInterval>(StockdataInterval.twentyFourHours);

    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:portfolio");
      return;
    }, ["_"]);
    final developmentMode =
        useState<PortfolioDevelopmentMode>(PortfolioDevelopmentMode.balance);

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
              displayInfoPage(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          TimeFilter(
            enabled: false,
            init: timeFilter.value,
            callback: (int a) {
              timeFilter.value = a;
            },
          ),
          SizedBox(
            height: 25,
          ),
          SwitchRow(options: [
            SwitchRowItem<PortfolioDevelopmentMode>(
              selected:
                  developmentMode.value == PortfolioDevelopmentMode.balance,
              callback: (v) => developmentMode.value = v,
              value: PortfolioDevelopmentMode.balance,
              text: AppLocalizations.of(context)!.dash_balance_switch,
            ),
            SwitchRowItem<PortfolioDevelopmentMode>(
              selected:
                  developmentMode.value == PortfolioDevelopmentMode.development,
              callback: (v) {}, // (v) => developmentMode.value = v,
              value: PortfolioDevelopmentMode.development,
              text: AppLocalizations.of(context)!.dash_development,
            )
          ]),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: developmentMode.value == PortfolioDevelopmentMode.balance
                  ? 20
                  : 60,
            ),
            child: developmentMode.value == PortfolioDevelopmentMode.balance
                ? PortfolioBalanceCard(
                    interval: interval.value,
                  )
                : PortfolioPerformanceCard(
                    interval: interval.value,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: BrandedOutlineButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FeatureNotImplemented()),
                        );
                      },
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Deposit(),
                          ),
                        );
                      },
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
          DifferenceCard(),
          SizedBox(
            height: 28,
          ),
          BestWorstCard(),
          GenericHeadline(
            title: AppLocalizations.of(context)!.port_allocation_title,
          ),
          DistributionWidget(),
          GenericHeadline(
            title: AppLocalizations.of(context)!.port_investments_title,
            linktext: AppLocalizations.of(context)!.port_view_all_link,
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CurrentInvestmentPage()),
              );
            },
          ),
          CurrentInvestmentsWidget(
            interval: interval.value,
          ),
          RecentlyClosedSection(),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
