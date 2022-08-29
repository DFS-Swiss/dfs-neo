import 'package:flutter/material.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/types/api/stockdata_bulk_fetch_request.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/stockdata_store.dart';

import '../enums/publisher_event.dart';
import '../service_locator.dart';

class StockdataService extends ChangeNotifier {
  final RESTService _restService = locator<RESTService>();
  final PublisherService _publisherService = locator<PublisherService>();
  final StockdataStore _stockdataStore = locator<StockdataStore>();

  StockdataService() {
    _publisherService.getSource().listen((e) {
      if (e == PublisherEvent.updateStockdata) {
        notifyListeners();
      } else if (e == PublisherEvent.logout) {
        _stockdataStore.clearCache();
      }
    });
  }

  final Map<String, List<StockdataInterval>> _bulkFetchCache = {};
  Future<void>? _bulkFetchTimer;

  List<StockdataDatapoint>? getDataFromCacheIfAvaliable(
      String symbol, StockdataInterval interval) {
    var data = _stockdataStore.getData(symbol);
    if (data != null) {
      if (data[interval] != null && data[interval]!.isStale()) {
        return data[interval]!.getSorted();
      }
      return null;
    }
    return null;
  }

  Stream<List<StockdataDatapoint>> getStockdata(
      String symbol, StockdataInterval interval) async* {
    var data = _stockdataStore.getData(symbol);
    if (data != null) {
      if (data[interval] != null) {
        yield data[interval]!.getSorted();
        if (data[interval]!.isStale()) {
          _registerFetchRequest(symbol, interval);
        }
      } else {
        _registerFetchRequest(symbol, interval);
      }
    } else {
      _registerFetchRequest(symbol, interval);
    }

    //TODO: Add logic to check if the relevant data was updated to prevent unecessary rerenders;
    yield* _stockdataStore
        .getDataStore()
        .where((event) =>
            event[symbol] != null && event[symbol]![interval] != null)
        .map((event) => event[symbol]![interval]!.getSorted());
  }

  Stream<StockdataDatapoint> getLatestPrice(String symbol) async* {
    yield* getStockdata(symbol, StockdataInterval.twentyFourHours).map(
      (event) => event.first,
    );
  }

  _registerFetchRequest(String symbol, StockdataInterval interval) {
    final shouldStartTimer = _bulkFetchCache.isEmpty && _bulkFetchTimer == null;
    if (_bulkFetchCache[symbol] == null) {
      _bulkFetchCache[symbol] = [interval];
    } else {
      _bulkFetchCache[symbol]!.add(interval);
    }
    if (shouldStartTimer) {
      _bulkFetchTimer =
          Future.delayed(Duration(milliseconds: 100), _handleBulkFetch);
    }
  }

  _handleBulkFetch() async {
    if (_bulkFetchCache.length > 1) {
      _restService.getStockdataBulk(
          StockdataBulkFetchRequest.fromMap({"symbols": _bulkFetchCache}));
    } else {
      final singleEntry = _bulkFetchCache.entries.first;
      if (singleEntry.value.length > 1) {
        _restService.getStockdataBulk(
            StockdataBulkFetchRequest.fromMap({"symbols": _bulkFetchCache}));
      } else {
        _restService.getStockdata(singleEntry.key, singleEntry.value.first);
      }
    }
    _bulkFetchCache.clear();
    _bulkFetchTimer = null;
  }

  handleWebsocketUpdate(List<dynamic> newData) {
    print("${DateTime.now().toIso8601String()}: Stock data update received");
    final List<StockdataDatapoint> castedData = [];

    for (var element in newData) {
      castedData.add(StockdataDatapoint.fromMap(element));
    }

    final Map<String, Map<StockdataInterval, List<StockdataDatapoint>>>
        tempMap = {};

    for (var singleDatapoint in castedData) {
      var existingData = [];
      var data = _stockdataStore.getData(singleDatapoint.symbol);
      if (data != null && data[StockdataInterval.twentyFourHours] != null) {
        existingData = _stockdataStore
            .getDataStore()
            .value[singleDatapoint.symbol]![StockdataInterval.twentyFourHours]!
            .getSorted();
      }
      if (existingData.isNotEmpty) {
        tempMap[singleDatapoint.symbol] = {
          StockdataInterval.twentyFourHours: [
            ...existingData.skip(1),
            singleDatapoint
          ]
        };
      }
    }
    if (tempMap.isNotEmpty) {
      _stockdataStore.updateData(tempMap);
    }
  }

  propagateError(
      Map<String, List<StockdataInterval>> relevantFields, dynamic error) {
    //TODO: Implement proper error propagation
  }
}
