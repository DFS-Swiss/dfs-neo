import 'package:rxdart/rxdart.dart';

class DataHandler {

  final Map<String, List<Function()>> _userDataHandlerRegister = {};
  final BehaviorSubject<Map<String, dynamic>> dataUpdateStream = BehaviorSubject();

  registerUserDataHandler(String entity, List<Function()> handler) {
    _userDataHandlerRegister[entity] = handler;
  }

  getUserDataHandlerRegister(){
    return _userDataHandlerRegister;
  }

  BehaviorSubject<Map<String, dynamic>> getDataUpdateStream(){
    return dataUpdateStream;
  }

  addToDataUpstream(String key, Object data){
    dataUpdateStream.add({"key": key, "value": data});
  }

  addErrorToDataUpstream(String key, Object e){
    dataUpdateStream.addError({"key": key, "value": e});
  }
}