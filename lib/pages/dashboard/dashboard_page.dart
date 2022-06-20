import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo/pages/dashboard/portfolio_balance_card.dart';
import '../../widgets/appbaractionbutton_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          AppBarActionButton(
            icon: Icons.notifications_none,
            callback: () {
              print("Tapped notifications");
            },
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.dash_greeting,
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            SizedBox(
              height: 24,
            ),
            PortfolioBalanceCard()
          ],
        ),
      ),
    );
  }
}
