import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../../hooks/use_balance_history.dart';

class DifferenceCard extends HookWidget {
  final StockdataInterval interval;
  const DifferenceCard({required this.interval, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceHistory = useBalanceHistory(interval);

    late final String title;
    switch (interval) {
      case StockdataInterval.twentyFourHours:
        title = AppLocalizations.of(context)!.port_overview_difday;
        break;
      case StockdataInterval.mtd:
        title = AppLocalizations.of(context)!.port_overview_difmtd;
        break;
      case StockdataInterval.ytd:
        title = AppLocalizations.of(context)!.port_overview_difytd;
        break;
      case StockdataInterval.oneYear:
        title = AppLocalizations.of(context)!.port_overview_difyear;
        break;
      case StockdataInterval.twoYears:
        title = AppLocalizations.of(context)!.port_overview_diflife;
        break;

      default:
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    balanceHistory.loading
                        ? "..."
                        : NumberFormat.currency(symbol: "dUSD ").format(
                            balanceHistory.data!.total.first.price -
                                balanceHistory.data!.total.last.price),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 0,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.port_overview_difbuy,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      balanceHistory.loading
                          ? "..."
                          : NumberFormat.currency(symbol: " dUSD ").format(
                              balanceHistory.data!.averagePL *
                                  balanceHistory.data!.inAssets.last.price),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
