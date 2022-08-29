import 'package:neo/enums/publisher_event.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:rxdart/rxdart.dart';

import '../models/stockdata_datapoint.dart';
import '../service_locator.dart';
import '../types/stockdata_interval_enum.dart';
import '../types/stockdata_storage_container.dart';

class StockdataStore {
  final PublisherService _publisherService = locator<PublisherService>();
  final BehaviorSubject<
          Map<String, Map<StockdataInterval, StockdataStorageContainer>>>
      _dataStore = BehaviorSubject.seeded({});

  BehaviorSubject<
          Map<String, Map<StockdataInterval, StockdataStorageContainer>>>
      getDataStore() {
    return _dataStore;
  }

  clearCache(){
    _dataStore.add({});
  }

  Map<StockdataInterval, StockdataStorageContainer>? getData(String symbol) {
    return _dataStore.value[symbol];
  }

  updateData(
    Map<String, Map<StockdataInterval, List<StockdataDatapoint>>> streamValue,
  ) {
    final tempStore = _dataStore.value;
    for (var singleSymbol in streamValue.entries) {
      if (tempStore[singleSymbol.key] == null) {
        tempStore[singleSymbol.key] = singleSymbol.value.map((key, value) {
          if (value.length < 2) {
            print("Error in update detected");
          }
          return MapEntry(
            key,
            StockdataStorageContainer(
              key,
              singleSymbol.key,
              value,
            ),
          );
        });
      } else {
        for (var singleInterval in singleSymbol.value.entries) {
          if (tempStore[singleSymbol.key]![singleInterval.key] != null) {
            if (singleInterval.value.length < 2) {
              print("Single entry detected, could be fine though");
            }
            tempStore[singleSymbol.key]![singleInterval.key]!
                .merge(singleInterval.value);
          } else {
            if (singleInterval.value.length < 2) {
              print("Error in update detected");
            }
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
    _publisherService.addEvent(PublisherEvent.updateStockdata);
  }
}
