import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

class DifferenceCard extends HookWidget {
  final StockdataInterval interval;
  const DifferenceCard({required this.interval, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = useState<String>("");
    useEffect(() {
      switch (interval) {
        case StockdataInterval.twentyFourHours:
          title.value = AppLocalizations.of(context)!.port_overview_difday;
          break;
          case StockdataInterval.mtd:
          title.value = AppLocalizations.of(context)!.port_overview_difday;
          break;
          case StockdataInterval.ytd:
          title.value = AppLocalizations.of(context)!.port_overview_difday;
          break;
          case StockdataInterval.oneYear:
          title.value = AppLocalizations.of(context)!.port_overview_difday;
          break;
          case StockdataInterval.twoYears:
          title.value = AppLocalizations.of(context)!.port_overview_difday;
          break;

        default:
      }
      return;
    }, [interval]);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.port_overview_difday,
              style: Theme.of(context).textTheme.bodySmall),
          SizedBox(
            height: 12,
          ),
          Text(
            "+ 400.00 dUSD",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
