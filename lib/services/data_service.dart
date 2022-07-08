import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/rest_service.dart';
import 'package:rxdart/subjects.dart';

import '../models/user_balance_datapoint.dart';

class DataService extends ChangeNotifier {
  DataService._();
  static DataService? _instance;
  static DataService getInstance() {
    return _instance ??= DataService._();
  }

  final Map<String, List<Function()>> _userDataHandlerRegister = {};

  BehaviorSubject<Map<String, dynamic>> dataUpdateStream = BehaviorSubject();

  registerUserDataHandler(String entity, List<Function()> handler) {
    _userDataHandlerRegister[entity] = handler;
  }

  handleUserDataUpdate(String message) {
    print(message);
    final Map<String, dynamic> json = JsonDecoder().convert(message);
    final entity = json["entity"];
    if (_userDataHandlerRegister[entity] != null) {
      for (var handler in _userDataHandlerRegister[entity]!) {
        handler();
      }
    } else {
      print("Unhandled enity update $entity");
    }
    notifyListeners();
  }

  Stream<UserModel> getUserData() async* {
    yield await RESTService.getInstance().getUserData();
    yield* dataUpdateStream
        .where((event) => event["key"] == "user")
        .map((event) {
      return event["value"];
    });
  }

  Stream<StockdataDocument> getStockInfo(String symbol) async* {
    yield await RESTService.getInstance().getStockInfo(symbol);
    yield* dataUpdateStream
        .where((event) => event["key"] == "symbol/$symbol")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<StockdataDocument>> getAvailableStocks() async* {
    yield await RESTService.getInstance().getAvailiableStocks();
    yield* dataUpdateStream
        .where((event) => event["key"] == "symbols")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<UserassetDatapoint>> getUserAssets() async* {
    yield await RESTService.getInstance().getUserAssets();
    yield* dataUpdateStream
        .where((event) => event["key"] == "investments")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<UserassetDatapoint>> getUserAssetsHistory() async* {
    yield await RESTService.getInstance().getUserAssetsHistory();
    yield* dataUpdateStream
        .where((event) => event["key"] == "investments/history")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<UserBalanceDatapoint>> getUserBalanceHistory() async* {
    yield await RESTService.getInstance().getUserBalanceHistory();
    yield* dataUpdateStream
        .where((event) => event["key"] == "balance/history")
        .map((event) {
      return event["value"];
    });
  }

  Stream<UserBalanceDatapoint> getUserBalance() async* {
    yield await RESTService.getInstance().getBalance();
    yield* dataUpdateStream
        .where((event) => event["key"] == "balance")
        .map((event) {
      return event["value"];
    });
  }

  Future<bool> buyAsset(String symbol, double amountInDollar) async {
    return RESTService.getInstance().buyAsset(symbol, amountInDollar);
  }
}
