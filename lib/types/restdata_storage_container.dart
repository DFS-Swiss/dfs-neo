import 'package:neo/constants/cache.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/websocket/websocket_controler.dart';

import '../services/websocket/websocket_service.dart';

class RestdataStorageContainer {
  DateTime lastSync;
  final dynamic data;

  RestdataStorageContainer(this.data) : lastSync = DateTime.now();

  bool isStale() {
    final socketState =
        locator<WebsocketService>().userDataConnectionStateStream.value;
    return socketState.state != SocketConnectionState.connected &&
        socketState.time.difference(DateTime.now()) >
            REST_CACHE_WITHOUT_CONN_STALE;
  }
}
