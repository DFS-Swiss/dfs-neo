import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/data_handler_service.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/types/restdata_storage_container.dart';
import 'package:rxdart/subjects.dart';

import '../enums/data_source.dart';
import '../models/user_balance_datapoint.dart';
import '../service_locator.dart';

class DataService extends ChangeNotifier {
  final RESTService _restService = locator<RESTService>();
  final DataHandlerService _dataHandlerService = locator<DataHandlerService>();
  final PublisherService _publisherService = locator<PublisherService>();

  DataService() {
    _dataHandlerService.getDataUpdateStream().listen((value) {
      final tempStore = _dataStore.value;
      tempStore[value["key"]] = RestdataStorageContainer(value["value"]);
      _dataStore.add(tempStore);
    });
    _publisherService.getSource().listen((e) {
      if (e == PublisherEvent.logout) {
        _dataStore.add({});
      }
    });
  }

  final BehaviorSubject<Map<String, RestdataStorageContainer>> _dataStore =
      BehaviorSubject.seeded({});

  handleUserDataUpdate(String message) {
    print(message);
    final Map<String, dynamic> json = JsonDecoder().convert(message);
    final entity = json["entity"];
    if (_dataHandlerService.getUserDataHandlerRegister()[entity] != null) {
      for (var handler
          in _dataHandlerService.getUserDataHandlerRegister()[entity]!) {
        handler();
      }
    } else {
      print("Unhandled enity update $entity");
    }
    notifyListeners();
  }

  T? getDataFromCacheIfAvaliable<T>(String key) {
    if (_dataStore.value[key] != null && !_dataStore.value[key]!.isStale()) {
      return _dataStore.value[key]!.data as T;
    }
    return null;
  }

  Stream<UserModel> getUserData({DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["user"] != null &&
        !_dataStore.value["user"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["user"]!.data as UserModel;
    } else {
      yield await _restService.getUserData();
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "user")
        .map((event) {
      return event["value"];
    });
  }

  Stream<StockdataDocument> getStockInfo(String symbol,
      {DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["symbol/$symbol"] != null &&
        !_dataStore.value["symbol/$symbol"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["symbol/$symbol"]!.data as StockdataDocument;
    } else {
      yield await _restService.getStockInfo(symbol);
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "symbol/$symbol")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<StockdataDocument>> getAvailableStocks(
      {DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["symbols"] != null &&
        !_dataStore.value["symbols"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["symbols"]!.data as List<StockdataDocument>;
    } else {
      yield await _restService.getAvailiableStocks();
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "symbols")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<UserassetDatapoint>> getUserAssets(
      {DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["investments"] != null &&
        !_dataStore.value["investments"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["investments"]!.data as List<UserassetDatapoint>;
    } else {
      yield await _restService.getUserAssets();
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "investments")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<UserassetDatapoint>> getUserAssetsHistory(
      {DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["investments/history"] != null &&
        !_dataStore.value["investments/history"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["investments/history"]!.data
          as List<UserassetDatapoint>;
    } else {
      yield await _restService.getUserAssetsHistory();
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "investments/history")
        .map((event) {
      return event["value"];
    });
  }

  Stream<List<UserBalanceDatapoint>> getUserBalanceHistory(
      {DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["balance/history"] != null &&
        !_dataStore.value["balance/history"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["balance/history"]!.data
          as List<UserBalanceDatapoint>;
    } else {
      yield await _restService.getUserBalanceHistory();
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "balance/history")
        .map((event) {
      return event["value"];
    });
  }

  Stream<UserBalanceDatapoint> getUserBalance(
      {DataSource source = DataSource.cache}) async* {
    if (_dataStore.value["balance"] != null &&
        !_dataStore.value["balance"]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value["balance"]!.data as UserBalanceDatapoint;
    } else {
      yield await _restService.getBalance();
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == "balance")
        .map((event) {
      return event["value"];
    });
  }

  Future<bool> buyAsset(String symbol, double amountInDollar) async {
    return _restService.buyAsset(symbol, amountInDollar);
  }

  Future<bool> sellAsset(String symbol, double ammountOfTokensToSell) async {
    return _restService.sellAsset(symbol, ammountOfTokensToSell);
  }

  Future<bool> addUserBalance(String amount) async {
    return await _restService.addBalance(amount);
  }

  Stream<List<UserassetDatapoint>> getUserAssetsForSymbol(
      String symbol) async* {
    yield await _restService.getAssetForSymbol(symbol);
  }
}
