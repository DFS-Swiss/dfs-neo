import 'dart:convert';

import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/services/websocket/websocket_controler.dart';
import 'package:rxdart/rxdart.dart';

class WebsocketService {
  WebsocketService._();
  static WebsocketService? _instance;
  static WebsocketService getInstance() {
    return _instance ??= WebsocketService._();
  }

  WebsocketControler? _userDataControler;
  WebsocketControler? _stockDataControler;
  BehaviorSubject<SocketConnectionState> stockDataConnectionStateStream =
      BehaviorSubject.seeded(SocketConnectionState.waiting);

  BehaviorSubject<SocketConnectionState> userDataConnectionStateStream =
      BehaviorSubject.seeded(SocketConnectionState.waiting);

  Future init() async {
    _stockDataControler = WebsocketControler("ws://stockdata.dfs-api.ch:8080");
    _userDataControler = WebsocketControler(
      "wss://websockets.dfs-api.ch",
      getApiKey: () => AuthenticationService.getInstance().getCurrentApiKey(),
    );
    _stockDataControler!.connectionStateStream
        .pipe(stockDataConnectionStateStream);
    _userDataControler!.connectionStateStream
        .pipe(userDataConnectionStateStream);
    _userDataControler!.streamController.stream.listen((event) {
      DataService.getInstance().handleUserDataUpdate(event);
    });
    _stockDataControler!.streamController.stream.listen((event) {
      StockdataService.getInstance()
          .handleWebsocketUpdate(JsonDecoder().convert(event));
    });
  }
}
