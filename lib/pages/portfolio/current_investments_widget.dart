import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_user_assets_with_values.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/widgets/cards/investment_card.dart';

class CurrentInvestmentsWidget extends HookWidget {
  final StockdataInterval interval;
  const CurrentInvestmentsWidget({Key? key, required this.interval})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investments = useUserAssetsWithValues();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: !investments.loading
            ? investments.data!
                .take(3)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InvestmentCard(
                      interval: interval,
                      token: e.symbol,
                      expandHorizontal: true,
                    ),
                  ),
                )
                .toList()
            : [
                InvestCardPlaceholder(),
                InvestCardPlaceholder(),
                InvestCardPlaceholder()
              ],
      ),
    );
  }
}
