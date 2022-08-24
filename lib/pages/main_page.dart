import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_user_data.dart';
import 'package:neo/hooks/use_websocket_connection_state.dart';
import 'package:neo/services/websocket/websocket_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../hooks/use_stockdata.dart';
import '../service_locator.dart';
import '../services/rest_service.dart';

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RESTService restService = locator<RESTService>();
    final connState = useStockDataSocketConnectionState();
    final connStateUser = useUserDataSocketConnectionState();
    final userData = useUserData();
    final stockdata = useStockdata("dAAPL", StockdataInterval.twentyFourHours);
    final stockdata2 = useStockdata("dAMZN", StockdataInterval.mtd);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("User data: ${userData.toString()}"),
            Divider(),
            Text(stockdata.loading
                ? "loading"
                : stockdata.data!.map((e) => e.time).toString()),
            Divider(),
            Text(stockdata2.loading
                ? "loading"
                : stockdata2.data!.map((e) => e.time).toString()),
            Divider(),
            Text("Stockdata: ${connState.name}"),
            Text("User data: ${connStateUser.name}"),
            TextButton(
              onPressed: () {
                restService
                    .getUserData()
                    .then((value) => print(value));
              },
              child: Text(
                "Test api connection",
              ),
            ),
            TextButton(
              onPressed: () {
                WebsocketService.getInstance().init();
              },
              child: Text(
                "Connect to user data socket",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
