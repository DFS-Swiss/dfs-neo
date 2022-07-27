import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/portfolio/timeperiod_widget.dart';

class TimeFilter extends HookWidget {
  final Function callback;
  final int init;
  const TimeFilter({required this.init, required this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterOptions = useState<int>(init);

    return Padding(
      padding: const EdgeInsets.only(
        top: 26,
      ),
      child: SizedBox(
        height: 32,
        child: Row(
          children: [
            SizedBox(
              width: 24,
            ),
            Expanded(
              child: TimePeriod(
                  currentlySelected: filterOptions.value,
                  id: 0,
                  text: "24H",
                  //text: AppLocalizations.of(context)!.port_time_today,
                  callback: (int a) {
                    filterOptions.value = a;
                    callback(a);
                  }),
            ),
            Expanded(
              child: TimePeriod(
                  currentlySelected: filterOptions.value,
                  id: 1,
                  text: "MTD",
                  //text: AppLocalizations.of(context)!.port_time_week,
                  callback: (int a) {
                    filterOptions.value = a;
                    callback(a);
                  }),
            ),
            Expanded(
              child: TimePeriod(
                  currentlySelected: filterOptions.value,
                  id: 2,
                  text: "YTD",
                  //text: AppLocalizations.of(context)!.port_time_month,
                  callback: (int a) {
                    filterOptions.value = a;
                    callback(a);
                  }),
            ),
            Expanded(
              child: TimePeriod(
                  currentlySelected: filterOptions.value,
                  id: 3,
                  text: "1Y",
                  //text: AppLocalizations.of(context)!.port_time_year,
                  callback: (int a) {
                    filterOptions.value = a;
                    callback(a);
                  }),
            ),
            Expanded(
              child: TimePeriod(
                  currentlySelected: filterOptions.value,
                  id: 4,
                  text: "2Y",
                  //text: AppLocalizations.of(context)!.port_time_lifetime,
                  callback: (int a) {
                    filterOptions.value = a;
                    callback(a);
                  }),
            ),
            SizedBox(
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
