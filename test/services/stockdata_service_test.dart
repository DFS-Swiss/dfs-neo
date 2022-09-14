import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest/rest_service.dart';
import 'package:neo/services/stockdata/stockdata_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';
import 'package:neo/types/stockdata_storage_container.dart';
import 'package:neo/services/stockdata/stockdata_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('Stock Data Service Test - Constructor', () {
    setUp(() {
      registerServices();
      var publisherService = locator<PublisherService>() as MockPublisherService;
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      publishSubject.add(PublisherEvent.logout);

      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
    });
    tearDown(() {
      unregisterServices();
    });

    test('constructor_handlersSetCorrectly', () async {
      // arrange
      StockdataService();
      var stockdataHandler = locator<StockdataHandler>() as MockStockdataHandler;
      // assert
      // verify(stockdataHandler.clearCache()).called(1);
    });
  });

  group('Stock Data Service Test - GetDataFromCacheIfAvailable', () {
    setUp(() {
      registerServices();
      var dataHandlerService = locator<StockdataHandler>();
      var publisherService = locator<PublisherService>();

      Map<StockdataInterval, StockdataStorageContainer> dataStore =
          <StockdataInterval, StockdataStorageContainer>{};
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();
      List<StockdataDatapoint> dataPoints = [];
      dataPoints.add(StockdataDatapoint(DateTime.now().add(const Duration(days: 1)), 3, "test"));
      var container = StockdataStorageContainer(StockdataInterval.mtd, "test", dataPoints);
      container.lastSync = DateTime.now().subtract(const Duration(days: 1));
      dataStore[StockdataInterval.mtd] = container;
          

      when(dataHandlerService.getData("test"))
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
    });
    tearDown(() {
      unregisterServices();
    });

    test('getDataFromCacheIfAvaliable_keyEmpty_returnsNull', () async {
      // arrange
      var dataService = StockdataService();
      var dataHandler = locator<StockdataHandler>();

      when(dataHandler.getData("")).thenAnswer((realInvocation) => null);

      // act
      var data =
          dataService.getDataFromCacheIfAvaliable("", StockdataInterval.mtd);

      // assert
      expect(data, null);
    });

    test('getDataFromCacheIfAvaliable_keyNotInDataStore_returnsNull', () async {
      // arrange
      var dataService = StockdataService();
      var dataHandler = locator<StockdataHandler>();

      when(dataHandler.getData("testy")).thenAnswer((realInvocation) => null);

      // act
      var cachedData = dataService.getDataFromCacheIfAvaliable(
          "testy", StockdataInterval.oneYear);

      // assert
      expect(cachedData, null);
    });

    test('getDataFromCacheIfAvaliable_keyInDataStore_returnsCorrectData',
        () async {
      // arrange
      var dataService = StockdataService();

      // act
      var cachedData = dataService.getDataFromCacheIfAvaliable(
          "test", StockdataInterval.mtd);

      // assert
      expect(cachedData!.length, 1);
    });
  });

  group('Stock Data Service Test - GetStockData', () {
    setUp(() {
      registerServices();
      var stockdataHandlerService = locator<StockdataHandler>();
      var publisherService = locator<PublisherService>();

      Map<StockdataInterval, StockdataStorageContainer> data =
          <StockdataInterval, StockdataStorageContainer>{};
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();
      final BehaviorSubject<
              Map<String, Map<StockdataInterval, StockdataStorageContainer>>>
          dataStore = BehaviorSubject<
              Map<String, Map<StockdataInterval, StockdataStorageContainer>>>();
      List<StockdataDatapoint> dataPoints = [];
      dataPoints.add(StockdataDatapoint(DateTime.now(), 3, "test"));

      data[StockdataInterval.mtd] =
          StockdataStorageContainer(StockdataInterval.mtd, "test", dataPoints);
      var behaviorData =
          <String, Map<StockdataInterval, StockdataStorageContainer>>{};
      behaviorData["test"] = data;

      dataStore.add(behaviorData);

      when(stockdataHandlerService.getData("test"))
          .thenAnswer((realInvocation) => data);
      when(stockdataHandlerService.getDataStore())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
    });
    tearDown(() {
      unregisterServices();
    });

    test('getDataFromCacheIfAvaliable_keyEmpty_returnsNull', () async {
      // arrange
      var dataService = StockdataService();
      var dataHandler = locator<StockdataHandler>();

      when(dataHandler.getData("")).thenAnswer((realInvocation) => null);

      // act
      var data = dataService.getStockdata("", StockdataInterval.mtd);

      var value = await data.isEmpty;

      // assert
      expect(value, true);
    });

    test('getDataFromCacheIfAvaliable_keyNotInDataStore_returnsNull', () async {
      // arrange
      var dataService = StockdataService();
      var dataHandler = locator<StockdataHandler>();
      var restService = locator<RESTService>();
      List<StockdataDatapoint> dataPoints = [];
      dataPoints.add(StockdataDatapoint(DateTime.now(), 2, "test"));

      when(dataHandler.getData("testy")).thenAnswer((realInvocation) => null);
      when(restService.getStockdata("testy", StockdataInterval.oneYear))
          .thenAnswer((realInvocation) => Future.value(dataPoints));

      // act
      var data = dataService.getStockdata("testy", StockdataInterval.oneYear);

      var value = await data.isEmpty;
      // assert
      expect(value, true);
    });

    test('getDataFromCacheIfAvaliable_keyInDataStore_returnsCorrectData',
        () async {
      // arrange
      var dataService = StockdataService();

      // act
      var cachedData = dataService.getStockdata("test", StockdataInterval.mtd);
      var data = await cachedData.first;

      // assert
      expect(data.length, 1);
    });
  });
}
