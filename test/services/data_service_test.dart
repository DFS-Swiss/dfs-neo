import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/crashlytics_service.dart';
import 'package:neo/services/data_handler_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/types/restdata_storage_container.dart';
import 'package:rxdart/rxdart.dart';

import '../helpers/test_helpers.dart';

class TestableDataService extends DataService {
  TestableDataService() : super();

  BehaviorSubject<Map<String, RestdataStorageContainer>> dataStore() {
    return super.getDataStore();
  }
}

void main() {
  group('Data Service Test -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    // BEWARE - Due to Constructor setup these tests behave on this particular order
    test('constructor_setupCorrectly', () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();

      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded({});
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);

      // act
      var dataService = TestableDataService();
      Map<String, dynamic> tempMap = <String, dynamic>{};
      tempMap["key"] = "test";
      tempMap["value"] = "test";
      dataStore.add(tempMap);

      locator.registerSingleton<TestableDataService>(dataService);
      // assert
    });

    test('constructor_handlersSetCorrectly', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // assert
      expect(dataService.dataStore().value.containsKey("test"), true);
    });

    test('constructor_logoutHandlesCorrectly', () async {
      // Complicated - we need to test this
    });

    test('handleUserDataUpdate_messageEmpty_NoException', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      dataService.handleUserDataUpdate("");

      // assert
      // TODO: Verify if Crashalytics was called
    });

    test('handleUserDataUpdate_messageDoesntIncludeEntity_NoException',
        () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      await dataService.handleUserDataUpdate("testy");

      // assert
      // TODO: Verify if Crashalytics was called
    });

    test('handleUserDataUpdate_registerNull_NoFunctionCalled', () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded({});
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
      when(dataHandlerService.getUserDataHandlerRegister()).thenReturn(null);

      var dataService = TestableDataService();

      // act
      dataService.handleUserDataUpdate("{\"entity\":\"test\"}");

      // assert

      verify(locator<CrashlyticsService>().leaveBreadcrumb("Unhandled enity update test")).called(1);
    });

    test('handleUserDataUpdate_registerDoesntContainEntity_NoFunctionCalled',
        () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded({});
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);

      Map<String, List<Function()>> register = <String, List<Function()>>{};
      when(dataHandlerService.getUserDataHandlerRegister())
          .thenReturn(register);

      var dataService = TestableDataService();

      // act
      dataService.handleUserDataUpdate("{\"entity\":\"test\"}");

      // assert
      verify(locator<CrashlyticsService>().leaveBreadcrumb("Unhandled enity update test")).called(1);
    });

    test('handleUserDataUpdate_registerContainsEntity_FunctionCalled',
        () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded({});
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);

      Map<String, List<Function()>> register = <String, List<Function()>>{};
      bool shouldBeTrue = false;
      register["test"] = <Function()>[];
      register["test"]?.add(() {shouldBeTrue = true;});
      when(dataHandlerService.getUserDataHandlerRegister())
          .thenReturn(register);

      var dataService = TestableDataService();

      // act
      dataService.handleUserDataUpdate("{\"entity\":\"test\"}");

      // assert
      expect(shouldBeTrue, true);
    });

    // TODO: Test other methods
  });
}
