import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/buy_sell/amount_selector.dart';

class BuyPage extends StatelessWidget {
  final String symbol;
  const BuyPage({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.share_buy} $symbol"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            AmountSelector()
          ],
        ),
      ),
    );
  }
}
