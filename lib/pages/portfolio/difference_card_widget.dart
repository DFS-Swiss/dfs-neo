import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/services/formatting_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/widgets/hideable_text.dart';

import '../../hooks/use_balance_history.dart';

class DifferenceCard extends HookWidget {
  const DifferenceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceHistory = useBalanceHistory(StockdataInterval.twentyFourHours);

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
                  Text(AppLocalizations.of(context)!.port_overview_difday,
                      style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                    height: 12,
                  ),
                  HideableText(
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
                    HideableText(
                      balanceHistory.loading
                          ? "..."
                          : "${FormattingService.calculatepercent(
                              balanceHistory.data!.total.first.price,
                              balanceHistory.data!.total.last.price,
                            )} %",
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
