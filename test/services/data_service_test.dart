import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/crashlytics_service.dart';
import 'package:neo/services/data_handler_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/rest_service.dart';
import 'package:neo/services/websocket/websocket_controler.dart';
import 'package:neo/services/websocket/websocket_service.dart';
import 'package:neo/types/restdata_storage_container.dart';
import 'package:neo/types/websocket_state_container.dart';
import 'package:rxdart/rxdart.dart';

import '../helpers/test_helpers.dart';

class TestableDataService extends DataService {
  TestableDataService() : super();

  BehaviorSubject<Map<String, RestdataStorageContainer>> dataStore() {
    return super.getDataStore();
  }
}

void main() {
  group('Data Service Test - Constructor', () {
    setUp(() {
      registerServices();
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      var data = <String, dynamic>{};
      data["key"] = "test";
      data["value"] = "test";

      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded(data);
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
      var dataService = TestableDataService();
      locator.registerSingleton<TestableDataService>(dataService);
    });
    tearDown(() {
      unregisterServices();
      locator.unregister<TestableDataService>();
    });

    test('constructor_handlersSetCorrectly', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // assert
      expect(dataService.dataStore().value.containsKey("test"), true);
    });
  });

  group("DataServiceTest - handleUserDataUpdate", () {
    setUp(() {
      registerServices();
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      var data = <String, dynamic>{};
      data["key"] = "test";
      data["value"] = "test";

      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded(data);
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
      var dataService = TestableDataService();
      locator.registerSingleton<TestableDataService>(dataService);
    });
    tearDown(() {
      unregisterServices();
      locator.unregister<TestableDataService>();
    });

    test('handleUserDataUpdate_messageEmpty_NoException', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      dataService.handleUserDataUpdate("");

      // assert
      verify(locator<CrashlyticsService>().leaveBreadcrumb("Empty Message"))
          .called(1);
    });

    test('handleUserDataUpdate_messageDoesntIncludeEntity_NoException',
        () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      await dataService.handleUserDataUpdate("testy");

      // assert
      verify(locator<CrashlyticsService>()
              .leaveBreadcrumb("Unappropriate Format"))
          .called(1);
    });

    test('handleUserDataUpdate_registerNull_NoFunctionCalled', () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      when(dataHandlerService.getUserDataHandlerRegister()).thenReturn(null);

      var dataService = locator<TestableDataService>();

      // act
      dataService.handleUserDataUpdate("{\"entity\":\"test\"}");

      // assert

      verify(locator<CrashlyticsService>()
              .leaveBreadcrumb("Unhandled enity update test"))
          .called(1);
    });

    test('handleUserDataUpdate_registerDoesntContainEntity_NoFunctionCalled',
        () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      Map<String, List<Function()>> register = <String, List<Function()>>{};
      when(dataHandlerService.getUserDataHandlerRegister())
          .thenReturn(register);

      var dataService = locator<TestableDataService>();

      // act
      dataService.handleUserDataUpdate("{\"entity\":\"test\"}");

      // assert
      verify(locator<CrashlyticsService>()
              .leaveBreadcrumb("Unhandled enity update test"))
          .called(1);
    });

    test('handleUserDataUpdate_registerContainsEntity_FunctionCalled',
        () async {
      // arrange
      var dataHandlerService = locator<DataHandlerService>();
      Map<String, List<Function()>> register = <String, List<Function()>>{};
      bool shouldBeTrue = false;
      register["test"] = <Function()>[];
      register["test"]?.add(() {
        shouldBeTrue = true;
      });
      when(dataHandlerService.getUserDataHandlerRegister())
          .thenReturn(register);

      var dataService = locator<TestableDataService>();

      // act
      dataService.handleUserDataUpdate("{\"entity\":\"test\"}");

      // assert
      expect(shouldBeTrue, true);
    });
  });

  group("DataServiceTest - getDataFromCacheIfAvailable", () {
    setUp(() {
      registerServices();
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      var webSocketService = locator<WebsocketService>();
      var data = <String, dynamic>{};
      data["key"] = "test";
      data["value"] = "test";

      WebsocketStateContainer webSocketData =
          WebsocketStateContainer(SocketConnectionState.connected);
      BehaviorSubject<WebsocketStateContainer> stateContainer =
          BehaviorSubject.seeded(webSocketData);
      when(webSocketService.userDataConnectionStateStream)
          .thenAnswer((realInvocation) => stateContainer);

      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded(data);
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
      var dataService = TestableDataService();
      locator.registerSingleton<TestableDataService>(dataService);
    });
    tearDown(() {
      unregisterServices();
      locator.unregister<TestableDataService>();
    });

    test('getDataFromCacheIfAvaliable_keyEmpty_returnsNull', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      var data = dataService.getDataFromCacheIfAvaliable("");

      // assert
      expect(data, null);
    });

    test('getDataFromCacheIfAvaliable_keyNotInDataStore_returnsNull', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      var cachedData = dataService.getDataFromCacheIfAvaliable("testy");

      // assert
      expect(cachedData, null);
    });

    test('getDataFromCacheIfAvaliable_keyInDataStore_returnsCorrectData',
        () async {
      // arrange
      var dataService = locator<TestableDataService>();
      var webSocketService = locator<WebsocketService>();
      var data = <String, dynamic>{};
      data["key"] = "test";
      data["value"] = "test";

      WebsocketStateContainer webSocketData =
          WebsocketStateContainer(SocketConnectionState.connected);
      BehaviorSubject<WebsocketStateContainer> stateContainer =
          BehaviorSubject.seeded(webSocketData);
      when(webSocketService.userDataConnectionStateStream)
          .thenAnswer((realInvocation) => stateContainer);

      // act
      var cachedData = dataService.getDataFromCacheIfAvaliable("test");

      // assert
      expect(cachedData, "test");
    });

    test('getDataFromCacheIfAvaliable_dataStoreNotStale_returnsTest', () async {
      // arrange
      var dataService = locator<TestableDataService>();

      // act
      var cachedData = dataService.getDataFromCacheIfAvaliable("test");

      // assert
      expect(cachedData, "test");
    });
  });

  group("DataServiceTest - getUserData", () {
    setUp(() {
      registerServices();
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      var webSocketService = locator<WebsocketService>();
      var restService = locator<RESTService>();

      UserModel testUser = UserModel(
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          referalCode: "123",
          inputWalletAdress: "inputWalletAdress",
          emailConfirmed: true,
          email: "email",
          id: "id");

      var data = <String, dynamic>{};
      data["key"] = "user";
      data["value"] = testUser;
      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded(data);
      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);

      WebsocketStateContainer webSocketData =
          WebsocketStateContainer(SocketConnectionState.connected);
      BehaviorSubject<WebsocketStateContainer> stateContainer =
          BehaviorSubject.seeded(webSocketData);
      when(webSocketService.userDataConnectionStateStream)
          .thenAnswer((realInvocation) => stateContainer);

      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);

      when(restService.getUserData()).thenAnswer((_) => Future.value(testUser));
    });
    tearDown(() {
      unregisterServices();
    });

    test('getUserData_userExists_returnsTestUser', () async {
      // arrange
      var dataService = TestableDataService();

      // act
      var userData = dataService.getUserData();
      String testEmail = "";
      await for (final value in userData) {
        testEmail = value.email;
        break;
      }

      // assert
      expect(testEmail, "email");
    });
  });

  group("DataServiceTest - getUserData", () {
    setUp(() {
      registerServices();
      var dataHandlerService = locator<DataHandlerService>();
      var publisherService = locator<PublisherService>();
      var webSocketService = locator<WebsocketService>();
      var restService = locator<RESTService>();

      UserModel testUser = UserModel(
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          referalCode: "123",
          inputWalletAdress: "inputWalletAdress",
          emailConfirmed: true,
          email: "email",
          id: "id");

      final BehaviorSubject<Map<String, dynamic>> dataStore =
          BehaviorSubject.seeded({});
      when(dataHandlerService.getDataUpdateStream())
          .thenAnswer((realInvocation) => dataStore);

      WebsocketStateContainer webSocketData =
          WebsocketStateContainer(SocketConnectionState.connected);
      BehaviorSubject<WebsocketStateContainer> stateContainer =
          BehaviorSubject.seeded(webSocketData);
      when(webSocketService.userDataConnectionStateStream)
          .thenAnswer((realInvocation) => stateContainer);

      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();
      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);

      when(restService.getUserData()).thenAnswer((_) => Future.value(testUser));
    });
    tearDown(() {
      unregisterServices();
    });
    test('getUserData_userDoesntExist_restServiceCalled', () async {
      // arrange
      var dataService = TestableDataService();
      
      // act
      var userData = dataService.getUserData();
      String email = "";
      await for (final value in userData) {
        email = value.email;
        break;
      }

      // assert
      expect(email, "email");
      verify(locator<RESTService>().getUserData()).called(1);
    });
  });
}
