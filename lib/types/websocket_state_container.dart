import '../services/websocket/websocket_controler.dart';

class WebsocketStateContainer {
  late DateTime time;
  final SocketConnectionState state;

  WebsocketStateContainer(this.state) : time = DateTime.now();
}
