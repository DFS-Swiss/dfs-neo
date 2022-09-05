import 'package:flutter/material.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/types/api/stockdata_bulk_fetch_request.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/utils/stockdata_handler.dart';

import '../enums/publisher_event.dart';
import '../service_locator.dart';

class StockdataService extends ChangeNotifier {
  final RESTService _restService = locator<RESTService>();
  final PublisherService _publisherService = locator<PublisherService>();
  final StockdataHandler _stockdataStore = locator<StockdataHandler>();

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
    if (data?[interval] != null && data![interval]!.isStale()) {
      return data[interval]!.getSorted();
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
      // Geht das leichter?
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

  propagateError(
      Map<String, List<StockdataInterval>> relevantFields, dynamic error) {
    //TODO: Implement proper error propagation
  }
}
