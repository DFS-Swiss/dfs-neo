import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/utils/data_handler.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/types/restdata_storage_container.dart';
import 'package:rxdart/subjects.dart';

import '../enums/data_source.dart';
import '../models/user_balance_datapoint.dart';
import '../service_locator.dart';
import 'crashlytics_service.dart';

class DataService extends ChangeNotifier {
  final RESTService _restService = locator<RESTService>();
  final DataHandler _dataHandlerService = locator<DataHandler>();
  final PublisherService _publisherService = locator<PublisherService>();
  final CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();

  DataService() {
    _publisherService.getSource().listen((e) {
      if (e == PublisherEvent.logout) {
        _dataHandlerService.clearCache();
      }
    });
  }

  handleUserDataUpdate(String message) {
    if (message.isEmpty) {
      _crashlyticsService.leaveBreadcrumb("Empty Message");
      print("Empty Message");
      return;
    }

    try {
      final Map<String, dynamic> json = JsonDecoder().convert(message);
      final entity = json["entity"];

      if (_dataHandlerService.getUserDataHandlerRegister()?[entity] != null) {
        for (var handler
            in _dataHandlerService.getUserDataHandlerRegister()[entity]!) {
          handler();
        }
      } else {
        _crashlyticsService.leaveBreadcrumb("Unhandled enity update $entity");
        print("Unhandled enity update $entity");
      }

      notifyListeners();
    } on FormatException {
      _crashlyticsService.leaveBreadcrumb("Unappropriate Format");
      print("Unappropriate Format");
    }
  }

  T? getDataFromCacheIfAvaliable<T>(String key) {
    var data = _dataHandlerService.getDataForKey(key);
    if (data != null && !data!.isStale()) {
      return data!.data as T;
    }
    return null;
  }

  Stream<UserModel> getUserData({DataSource source = DataSource.cache}) async* {
    var data = _dataHandlerService.getDataForKey("user");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as UserModel;
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
    var data = _dataHandlerService.getDataForKey("symbol/$symbol");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as StockdataDocument;
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
    var data = _dataHandlerService.getDataForKey("symbols");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as List<StockdataDocument>;
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
    var data = _dataHandlerService.getDataForKey("investments");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as List<UserassetDatapoint>;
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
    var data = _dataHandlerService.getDataForKey("investments/history");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as List<UserassetDatapoint>;
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
    var data = _dataHandlerService.getDataForKey("balance/history");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as List<UserBalanceDatapoint>;
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
         var data = _dataHandlerService.getDataForKey("balance");
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as UserBalanceDatapoint;
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

  Stream<T> getData<T>(String key, Future<T> callback,
      {DataSource source = DataSource.cache}) async* {
    var data = _dataHandlerService.getDataForKey(key);
    if (data != null && !data!.isStale() && source == DataSource.cache) {
      yield data!.data as T;
    } else {
      yield await callback;
    }
    yield* _dataHandlerService
        .getDataUpdateStream()
        .where((event) => event["key"] == key)
        .map((event) {
      return event["value"];
    });
  }

  // Only for testing the class
  @protected
  BehaviorSubject<Map<String, RestdataStorageContainer>> getDataStore() {
    return _dataHandlerService.getDataStore();
  }
}
