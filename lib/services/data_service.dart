import 'dart:convert';
import 'dart:developer';

import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/services/rest_service.dart';
import 'package:rxdart/subjects.dart';

class DataService {
  DataService._();
  static DataService? _instance;
  static DataService getInstance() {
    return _instance ??= DataService._();
  }

  final Map<String, Function()> _userDataHandlerRegister = {};

  BehaviorSubject<Map<String, dynamic>> dataUpdateStream = BehaviorSubject();

  registerUserDataHandler(String entity, Function() handler) {
    _userDataHandlerRegister[entity] = handler;
  }

  handleUserDataUpdate(String message) {
    final Map<String, dynamic> json = JsonDecoder().convert(message);
    final entity = json["entity"];
    if (_userDataHandlerRegister[entity] != null) {
      _userDataHandlerRegister[entity]!();
    } else {
      print("Unhandled enity update $entity");
    }
  }

  Stream<UserModel> getUserData() async* {
    yield await RESTService.getInstance().getUserData();
    yield* dataUpdateStream
        .where((event) => event["key"] == "user")
        .map((event) {
      log(event.toString());
      return event["value"];
    });
  }

  Stream<StockdataDocument> getStockInfo(String symbol) async* {
    yield await RESTService.getInstance().getStockInfo(symbol);
    yield* dataUpdateStream
        .where((event) => event["key"] == "symbol/$symbol")
        .map((event) {
      log(event.toString());
      return event["value"];
    });
  }

  Stream<List<StockdataDocument>> getAvailableStocks() async* {
    yield await RESTService.getInstance().getAvailiableStocks();
    yield* dataUpdateStream
        .where((event) => event["key"] == "symbols")
        .map((event) {
      log(event.toString());
      return event["value"];
    });
  }
}
