import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/types/api/stockdata_bulk_fetch_request.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/types/stockdata_storage_container.dart';
import 'package:rxdart/rxdart.dart';

class StockdataService {
  static StockdataService? _instance;
  static StockdataService getInstance() {
    return _instance ??= StockdataService._();
  }

  StockdataService._();

  final BehaviorSubject<
          Map<String, Map<StockdataInterval, StockdataStorageContainer>>>
      _dataStore = BehaviorSubject.seeded({});

  final Map<String, List<StockdataInterval>> _bulkFetchCache = {};
  Future<void>? _bulkFetchTimer;

  Stream<List<StockdataDatapoint>> getStockdata(
      String symbol, StockdataInterval interval) async* {
    if (_dataStore.value[symbol] != null) {
      if (_dataStore.value[symbol]![interval] != null) {
        yield _dataStore.value[symbol]![interval]!.getSorted();
        if (_dataStore.value[symbol]![interval]!.isStale()) {
          _registerFetchRequest(symbol, interval);
        }
      } else {
        _registerFetchRequest(symbol, interval);
      }
    } else {
      _registerFetchRequest(symbol, interval);
    }

    //TODO: Add logic to check if the relevant data was updated to prevent unecessary rerenders;
    yield* _dataStore
        .where((event) =>
            event[symbol] != null && event[symbol]![interval] != null)
        .map((event) => event[symbol]![interval]!.getSorted());
  }

  Stream<double> getLatestPrice(String symbol) async* {
    yield* getStockdata(symbol, StockdataInterval.twentyFourHours).map(
      (event) => event.first.price,
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
      RESTService.getInstance().getStockdataBulk(
          StockdataBulkFetchRequest.fromMap({"symbols": _bulkFetchCache}));
    } else {
      final singleEntry = _bulkFetchCache.entries.first;
      if (singleEntry.value.length > 1) {
        RESTService.getInstance().getStockdataBulk(
            StockdataBulkFetchRequest.fromMap({"symbols": _bulkFetchCache}));
      } else {
        RESTService.getInstance()
            .getStockdata(singleEntry.key, singleEntry.value.first);
      }
    }
    _bulkFetchCache.clear();
    _bulkFetchTimer = null;
  }

  handleWebsocketUpdate(List<dynamic> newData) {
    final List<StockdataDatapoint> castedData = [];

    for (var element in newData) {
      castedData.add(StockdataDatapoint.fromMap(element));
    }

    final Map<String, Map<StockdataInterval, List<StockdataDatapoint>>>
        tempMap = {};
    for (var singleDatapoint in castedData) {
      tempMap[singleDatapoint.symbol] = {
        StockdataInterval.twentyFourHours: [singleDatapoint]
      };
    }
    updateData(tempMap);
  }

  updateData(
    Map<String, Map<StockdataInterval, List<StockdataDatapoint>>> streamValue,
  ) {
    final tempStore = _dataStore.value;
    for (var singleSymbol in streamValue.entries) {
      if (tempStore[singleSymbol.key] == null) {
        tempStore[singleSymbol.key] = singleSymbol.value.map(
          (key, value) => MapEntry(
            key,
            StockdataStorageContainer(
              key,
              singleSymbol.key,
              value,
            ),
          ),
        );
      } else {
        for (var singleInterval in singleSymbol.value.entries) {
          if (tempStore[singleSymbol.key]![singleInterval.key] != null) {
            tempStore[singleSymbol.key]![singleInterval.key]!
                .merge(singleInterval.value);
          } else {
            tempStore[singleSymbol.key]![singleInterval.key] =
                StockdataStorageContainer(
              singleInterval.key,
              singleSymbol.key,
              singleInterval.value,
            );
          }
        }
      }
    }
    _dataStore.add(tempStore);
  }

  propagateError(
      Map<String, List<StockdataInterval>> relevantFields, dynamic error) {
    //TODO: Implement proper error propagation
  }
}
