import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/websocket/websocket_service.dart';

import '../services/websocket/websocket_controler.dart';

SocketConnectionState useUserDataSocketConnectionState() {
  final state = useState(
      locator<WebsocketService>().userDataConnectionStateStream.value);

  useEffect(() {
    final sub = locator<WebsocketService>()
        .userDataConnectionStateStream
        .listen((value) {
      state.value = value;
    });
    return sub.cancel;
  });
  return state.value.state;
}

SocketConnectionState useStockDataSocketConnectionState() {
  final state = useState(
      locator<WebsocketService>().stockDataConnectionStateStream.value);

  useEffect(() {
    final sub = locator<WebsocketService>()
        .stockDataConnectionStateStream
        .listen((value) {
      state.value = value;
    });
    return sub.cancel;
  });
  return state.value.state;
}
