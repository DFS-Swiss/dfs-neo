import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/stocklist/stocklist_page.dart';

class MainNavigation extends HookWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPage = useState<int>(0);

    getBody() {
      //TODO: Link pages when built
      switch (currentPage.value) {
        case 0:
          return Container(
            color: Colors.teal,
          );
        case 1:
          return Container(
            color: Colors.orangeAccent,
          );
        case 2:
          return StockList();
        default:
          return Container(
            color: Colors.teal,
          );
      }
    }

    return Scaffold(
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          currentPage.value = i;
        },
        currentIndex: currentPage.value,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: AppLocalizations.of(context)!.bottomnav_home),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.data_saver_off,
            ),
            label: AppLocalizations.of(context)!.bottomnav_port,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.line_axis_outlined,
              ),
              label: AppLocalizations.of(context)!.bottomnav_trade),
        ],
      ),
    );
  }
}