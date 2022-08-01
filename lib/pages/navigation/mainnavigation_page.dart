import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/account/account_page.dart';
import 'package:neo/pages/dashboard/dashboard_page.dart';
import 'package:neo/pages/portfolio/portfolio_page.dart';
import 'package:neo/pages/stocklist/stocklist_page.dart';
import 'package:neo/services/biometric_auth_service.dart';
import 'package:neo/services/prefetching_service.dart';
import 'package:neo/services/websocket/websocket_service.dart';

import '../../widgets/prefetching_loader.dart';

class MainNavigation extends HookWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPage = useState<int>(0);
    final prefetching = useState(true);
    final authing = useState(true);
    final comesFromBackground = useRef(false);
    final lastAuthRequest = useRef(DateTime(2000));

    final faceIdReason = AppLocalizations.of(context)!.faceID_reason;

    useOnAppLifecycleStateChange(((previous, current) {
      if (previous == AppLifecycleState.resumed &&
          (current == AppLifecycleState.inactive ||
              current == AppLifecycleState.paused)) {
        lastAuthRequest.value = DateTime.now();
        comesFromBackground.value = true;
        return;
      }

      if (!authing.value &&
          comesFromBackground.value &&
          lastAuthRequest.value
              .isBefore(DateTime.now().subtract(Duration(minutes: 1)))) {
        comesFromBackground.value = false;
        lastAuthRequest.value = DateTime.now();
        authing.value = true;

        BiometricAuth()
            .ensureAuthed(
              localizedReason: faceIdReason,
            )
            .then((value) => authing.value = false);
      }
    }));

    useEffect(() {
      WebsocketService.getInstance().init();
      BiometricAuth()
          .ensureAuthed(
        localizedReason: faceIdReason,
      )
          .then((value) {
        authing.value = false;
        lastAuthRequest.value = DateTime.now();
      });
      PrefetchingService()
          .prepareApp()
          .then((value) => prefetching.value = false);
      return;
    }, ["_"]);
    getBody() {
      switch (currentPage.value) {
        case 0:
          return DashboardPage();
        case 1:
          return Portfolio();
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

    return prefetching.value || authing.value
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
