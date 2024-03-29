import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/deposit/deposit_page.dart';
import 'package:neo/widgets/buttons/branded_button.dart';

import '../../hooks/use_balance.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartTradingSection extends HookWidget {
  const StartTradingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balance = useBalance();

    if (balance.loading) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Expanded(
                child: BrandedButton(
                    onPressed: () { Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Deposit()),
                    );
                  },
                child: Text(AppLocalizations.of(context)!.dash_deposit)))
          ],
        ),
      );
    }
  }
}
