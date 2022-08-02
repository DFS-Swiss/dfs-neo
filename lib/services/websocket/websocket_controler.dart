import 'dart:async';
import 'dart:io';

import 'package:rxdart/subjects.dart';

import '../../types/websocket_state_container.dart';

enum SocketConnectionState { connected, connecting, waiting, error }

class WebsocketControler {
  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  BehaviorSubject<WebsocketStateContainer> connectionStateStream =
      BehaviorSubject.seeded(
          WebsocketStateContainer(SocketConnectionState.waiting));

  String wsUrl;
  Future<String?> Function()? getApiKey;

  WebSocket? channel;

  int retryCount = 0;

  WebsocketControler(this.wsUrl, {this.getApiKey}) {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    print("conecting...");
    connectionStateStream
        .add(WebsocketStateContainer(SocketConnectionState.connecting));
    channel = await connectWs();
    print(
        "${DateTime.now().toIso8601String()}: socket connection to $wsUrl initializied");
    connectionStateStream
        .add(WebsocketStateContainer(SocketConnectionState.connected));
    channel!.done.then((_) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() {
    channel!.listen((streamData) {
      streamController.add(streamData);
    }, onDone: () {
      print("${DateTime.now().toIso8601String()}: conecting to $wsUrl aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('Server error: $e');
      initWebSocketConnection();
    });
  }

  connectWs() async {
    try {
      if (getApiKey != null) {
        final key = await getApiKey!();
        return await WebSocket.connect(
          wsUrl,
          headers: {
            "Authorization": key,
          },
        );
      }
      return await WebSocket.connect(wsUrl);
    } catch (e) {
      if (retryCount < 5) {
        retryCount++;
        await Future.delayed(Duration(milliseconds: 100 * (retryCount + 1)));
        return await connectWs();
      }
      connectionStateStream
          .add(WebsocketStateContainer(SocketConnectionState.error));
      throw "Error! Can not connect WS connectWs ${e.toString()}";
      //await Future.delayed(Duration(milliseconds: 10000));
      //return await connectWs();
    }
  }

  void _onDisconnected() {
    print("Lost connection, reconnecting");
    initWebSocketConnection();
  }
}
