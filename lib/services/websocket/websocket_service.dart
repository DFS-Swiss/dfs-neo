import 'dart:convert';

import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/services/websocket/websocket_controler.dart';
import 'package:rxdart/rxdart.dart';

import '../../service_locator.dart';
import '../../types/websocket_state_container.dart';

class WebsocketService {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DataService _dataService =
      locator<DataService>();

  WebsocketControler? _userDataControler;
  WebsocketControler? _stockDataControler;
  BehaviorSubject<WebsocketStateContainer> stockDataConnectionStateStream =
      BehaviorSubject.seeded(
          WebsocketStateContainer(SocketConnectionState.waiting));

  BehaviorSubject<WebsocketStateContainer> userDataConnectionStateStream =
      BehaviorSubject.seeded(
          WebsocketStateContainer(SocketConnectionState.waiting));

  Future init() async {
    _stockDataControler = WebsocketControler("ws://stockdata.dfs-api.ch:8080");
    _userDataControler = WebsocketControler(
      "wss://websockets.dfs-api.ch",
      getApiKey: () => _authenticationService.getCurrentApiKey(),
    );
    _stockDataControler!.connectionStateStream
        .pipe(stockDataConnectionStateStream);
    _stockDataControler!.initWebSocketConnection();
    _userDataControler!.connectionStateStream
        .pipe(userDataConnectionStateStream);
    _userDataControler!.initWebSocketConnection();
    _userDataControler!.streamController.stream.listen((event) {
      _dataService.handleUserDataUpdate(event);
    });
    _stockDataControler!.streamController.stream.listen((event) {
      StockdataService.getInstance()
          .handleWebsocketUpdate(JsonDecoder().convert(event));
    });
  }
}
