import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo/pages/dashboard/portfolio_balance_card.dart';
import 'package:neo/pages/dashboard/recently_closed_section.dart';
import 'package:neo/pages/dashboard/start_trading_section.dart';
import 'package:neo/utils/display_popup.dart';
import '../../hooks/use_user_data.dart';
import '../../service_locator.dart';
import '../../services/analytics_service.dart';
import '../../widgets/appbaractionbutton_widget.dart';
import 'current_investments_section.dart';
import 'open_orders_section.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = useUserData();

    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:dashboard");
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          AppBarActionButton(
            icon: Icons.notifications_none,
            callback: () {
              displayInfoPage(context);
            },
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context)!.dash_greeting}, ${userData.loading ? "..." : userData.data!.id}",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.dash_welcome_back,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: ListView(
          children: const [
            const SizedBox(
              height: 17,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: const PortfolioBalanceCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StartTradingSection(),
            ),
            CurrentInvestmentsSection(),
            RecentlyClosedSection(),
            OpenOrdersSection(),
            const SizedBox(
              height: 17,
            ),
          ],
        ),
      ),
    );
  }
}
