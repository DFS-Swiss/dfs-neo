import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/portfolio/timefilter_widget.dart';
import 'package:neo/widgets/appbaractionbutton_widget.dart';

class Portfolio extends HookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFilter = useState<int>(0);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.port_title),
        actions: [
          AppBarActionButton(
            icon: Icons.notifications_none,
            callback: () {
              print("Tapped notifications");
            },
          ),
        ],
      ),
      body: ListView(
        children: [TimeFilter(init: timeFilter.value, callback: () {})],
      ),
    );
  }
}
