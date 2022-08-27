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
import 'crashlytics_service.dart';

class DataService extends ChangeNotifier {
  final RESTService _restService = locator<RESTService>();
  final DataHandlerService _dataHandlerService = locator<DataHandlerService>();
  final PublisherService _publisherService = locator<PublisherService>();
  final CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();

  DataService() {
    _dataHandlerService.getDataUpdateStream().listen((value) {
      if (value.isNotEmpty) {
        final tempStore = _dataStore.value;
        if (value["key"] != null) {
          tempStore[value["key"]] = RestdataStorageContainer(value["value"]);
          _dataStore.add(tempStore);
        }
      }
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
    if (_dataStore.value[key] != null && !_dataStore.value[key]!.isStale()) {
      return _dataStore.value[key]!.data as T;
    }
    return null;
  }

  Stream<UserModel> getUserData({DataSource source = DataSource.cache}) {
    return getData<UserModel>("user", _restService.getUserData(), source: source);
  }

  Stream<StockdataDocument> getStockInfo(String symbol,
      {DataSource source = DataSource.cache}) {
    return getData<StockdataDocument>("symbol/$symbol", _restService.getStockInfo(symbol),
        source: source);
  }

  Stream<List<StockdataDocument>> getAvailableStocks(
      {DataSource source = DataSource.cache}) {
    return getData<List<StockdataDocument>>("symbols", _restService.getAvailiableStocks(), source: source);
  }

  Stream<List<UserassetDatapoint>> getUserAssets(
      {DataSource source = DataSource.cache}) {
    return getData<List<UserassetDatapoint>>("investments", _restService.getUserAssets(), source: source);
  }

  Stream<List<UserassetDatapoint>> getUserAssetsHistory(
      {DataSource source = DataSource.cache}) {
    return getData<List<UserassetDatapoint>>("investments/history", _restService.getUserAssetsHistory(),
        source: source);
  }

  Stream<List<UserBalanceDatapoint>> getUserBalanceHistory(
      {DataSource source = DataSource.cache}) {
    return getData<List<UserBalanceDatapoint>>("balance/history", _restService.getUserBalanceHistory(),
        source: source);
  }

  Stream<UserBalanceDatapoint> getUserBalance(
      {DataSource source = DataSource.cache}) {
    return getData<UserBalanceDatapoint>("balance", _restService.getBalance(), source: source);
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
    if (_dataStore.value[key] != null &&
        !_dataStore.value[key]!.isStale() &&
        source == DataSource.cache) {
      yield _dataStore.value[key]!.data as T;
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
    return _dataStore;
  }
}
