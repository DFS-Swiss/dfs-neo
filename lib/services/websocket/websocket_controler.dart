import 'dart:async';
import 'dart:io';

import 'package:rxdart/subjects.dart';

enum SocketConnectionState { connected, connecting, waiting, error }

class WebsocketControler {
  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  BehaviorSubject<SocketConnectionState> connectionStateStream =
      BehaviorSubject.seeded(SocketConnectionState.waiting);

  String wsUrl;
  Future<String?> Function()? getApiKey;

  WebSocket? channel;

  WebsocketControler(this.wsUrl, {this.getApiKey}) {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    print("conecting...");
    connectionStateStream.add(SocketConnectionState.connecting);
    channel = await connectWs();
    print("socket connection initializied");
    connectionStateStream.add(SocketConnectionState.connected);
    channel!.done.then((_) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() {
    channel!.listen((streamData) {
      streamController.add(streamData);
    }, onDone: () {
      print("conecting aborted");
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
      connectionStateStream.add(SocketConnectionState.error);
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
