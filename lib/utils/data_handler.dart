import 'package:rxdart/rxdart.dart';

import '../types/restdata_storage_container.dart';

class DataHandler {
  final Map<String, List<Function()>> _userDataHandlerRegister = {};
  final BehaviorSubject<Map<String, dynamic>> dataUpdateStream =
      BehaviorSubject();

  final BehaviorSubject<Map<String, RestdataStorageContainer>> _dataStore =
      BehaviorSubject.seeded({});


  DataHandler(){
    dataUpdateStream.listen((value) {
      if (value.isNotEmpty) {
        final tempStore = _dataStore.value;
        if (value["key"] != null) {
          tempStore[value["key"]] = RestdataStorageContainer(value["value"]);
          _dataStore.add(tempStore);
        }
      }
    });
  }

  getDataStore() {
    return _dataStore;
  }

  getDataForKey(String key) {
    return _dataStore.value[key];
  }

  registerUserDataHandler(String entity, List<Function()> handler) {
    _userDataHandlerRegister[entity] = handler;
  }

  getUserDataHandlerRegister() {
    return _userDataHandlerRegister;
  }

  BehaviorSubject<Map<String, dynamic>> getDataUpdateStream() {
    return dataUpdateStream;
  }

  addToDataUpstream(String key, Object data) {
    dataUpdateStream.add({"key": key, "value": data});
  }

  addErrorToDataUpstream(String key, Object e) {
    dataUpdateStream.addError({"key": key, "value": e});
  }

  void emptyCache() {
    _dataStore.add({});
  }
}
