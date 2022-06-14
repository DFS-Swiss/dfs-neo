import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/websocket/websocket_service.dart';

import '../services/websocket/websocket_controler.dart';

SocketConnectionState useUserDataSocketConnectionState() {
  final state = useState(
      WebsocketService.getInstance().userDataConnectionStateStream.value);

  useEffect(() {
    final sub = WebsocketService.getInstance()
        .userDataConnectionStateStream
        .listen((value) {
      state.value = value;
    });
    return sub.cancel;
  });
  return state.value;
}

SocketConnectionState useStockDataSocketConnectionState() {
  final state = useState(
      WebsocketService.getInstance().stockDataConnectionStateStream.value);

  useEffect(() {
    final sub = WebsocketService.getInstance()
        .stockDataConnectionStateStream
        .listen((value) {
      state.value = value;
    });
    return sub.cancel;
  });
  return state.value;
}
