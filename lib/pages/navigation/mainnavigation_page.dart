import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/account/account_page.dart';
import 'package:neo/pages/dashboard/dashboard_page.dart';
import 'package:neo/pages/stocklist/stocklist_page.dart';
import 'package:neo/services/prefetching_service.dart';
import 'package:neo/services/websocket/websocket_service.dart';

import '../../widgets/prefetching_loader.dart';

class MainNavigation extends HookWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPage = useState<int>(0);
    final prefetching = useState(true);
    useEffect(() {
      WebsocketService.getInstance().init();
      PrefetchingService()
          .prepareApp()
          .then((value) => prefetching.value = false);
      return;
    }, ["_"]);
    getBody() {
      //TODO: Link pages when built
      switch (currentPage.value) {
        case 0:
          return DashboardPage();
        case 1:
          return Container(
            color: Colors.orangeAccent,
          );
        case 2:
          return StockList();
        case 3:
          return AccountPage();
        default:
          return Container(
            color: Colors.teal,
          );
      }
    }

    return prefetching.value
        ? Scaffold(
            body: PrefetchingLoader(),
          )
        : Scaffold(
            body: getBody(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
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
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                    ),
                    label: AppLocalizations.of(context)!.nav_acc),
              ],
            ),
          );
  }
}
