import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/rest/dio_handler.dart';
import 'package:neo/services/rest/rest_service.dart';
import 'package:neo/services/data/data_handler.dart';
import 'package:neo/services/stockdata/stockdata_handler.dart';
import 'package:neo/types/api/stockdata_bulk_fetch_request.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('Rest Service Test - Constructor', () {
    setUp(() {
      registerServices();
    });
    tearDown(() {
      unregisterServices();
    });

    test('constructor_handlersSetCorrectly', () async {
      // arrange
      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.registerUserDataHandler(any, any)).thenReturn(null);

      // act
      RESTService();

      // assert
      verify(dataHandler.registerUserDataHandler(any, any)).called(3);
    });
  });

  group('Rest Service Test - Requests', () {
    setUp(() {
      registerServices();
      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.registerUserDataHandler(any, any)).thenReturn(null);
    });
    tearDown(() {
      unregisterServices();
    });

    test('getUserData_dataReceived_addedDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "createdAt": DateTime.now().toString(),
                "lastLogin": DateTime.now().toString(),
                "firstName": "test",
                "surName": "test",
                "referalCode": "test",
                "inputWalletAdress": "test",
                "emailConfirmed": true,
                "email": "test",
                "id": "test"
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getUserData();

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getUserData_notParsable_addedErrorToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ));

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addErrorToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getUserData();
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getStockInfo_stockInfoReceived_addedDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "assetType": "test",
                "symbol": "test",
                "displayName": "test",
                "imageUrl": "test",
                "description": "test",
                "publicSentimentIndex": 3,
                "displayColor": null,
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getStockInfo("AAPL");

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getStockInfo_notParsable_addedErrorToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "assetType": "test",
                "symbol": "test",
                "displayName": "test",
                "imageUrl": "test",
                "description": "test",
                "publicSentimentIndex": "3",
                "displayColor": null,
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addErrorToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getStockInfo("AAPL");
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getStockInfoBulk_stockInfoBulkReceived_addedDataToUpstream',
        () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "dAAPL": {
                    "assetType": "test",
                    "symbol": "test",
                    "displayName": "test",
                    "imageUrl": "test",
                    "description": "test",
                    "publicSentimentIndex": 3,
                    "displayColor": null,
                  }
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getStockInfoBulk(["AAPL"]);

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getStockInfoBulk_notParsable_addedErrorToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "assetType": "test",
                "symbol": "test",
                "displayName": "test",
                "imageUrl": "test",
                "description": "test",
                "publicSentimentIndex": "3",
                "displayColor": null,
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addErrorToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getStockInfoBulk(["AAPL"]);
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getStockdata_stockdataReceived_updatedStockData', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "time": DateTime.now().toString(),
                  "symbol": "test",
                  "price": 33.33,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<StockdataHandler>() as MockStockdataHandler;
      when(dataHandler.updateData(any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getStockdata("AAPL", StockdataInterval.twoYears);

      // assert
      verify(dataHandler.updateData(any)).called(1);
    });

    test('getStockdata_notParsable_noStockdataUpdate', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "assetType": "test",
                "symbol": "test",
                "displayName": "test",
                "imageUrl": "test",
                "description": "test",
                "publicSentimentIndex": "3",
                "displayColor": null,
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<StockdataHandler>() as MockStockdataHandler;
      when(dataHandler.updateData(any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getStockdata("AAPL", StockdataInterval.twoYears);
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verifyNever(dataHandler.updateData(any));
    });

    test('getStockdataBulk_stockdataBulkReceived_updatedStockData', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "symbols": {
                "AAPL": {
                  "mtd": [
                    {
                      "time": DateTime.now().toString(),
                      "symbol": "test",
                      "price": 44.44,
                    },
                    {
                      "time": DateTime.now().toString(),
                      "symbol": "test",
                      "price": 33.33,
                    },
                    {
                      "time": DateTime.now().toString(),
                      "symbol": "test",
                      "price": 55.55,
                    },
                  ]
                }
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.post(any, data: anyNamed("data")))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<StockdataHandler>() as MockStockdataHandler;
      when(dataHandler.updateData(any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getStockdataBulk(StockdataBulkFetchRequest(symbols: {
        "AAPL": [StockdataInterval.oneYear]
      }));

      // assert
      verify(dataHandler.updateData(any)).called(1);
    });

    test('getStockdataBulk_notParsable_noStockdataUpdate', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "assetType": "test",
                "symbol": "test",
                "displayName": "test",
                "imageUrl": "test",
                "description": "test",
                "publicSentimentIndex": "3",
                "displayColor": null,
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<StockdataHandler>() as MockStockdataHandler;
      when(dataHandler.updateData(any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getStockdataBulk(StockdataBulkFetchRequest(symbols: {
          "AAPL": [StockdataInterval.oneYear]
        }));
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verifyNever(dataHandler.updateData(any));
    });

    test('addBalance_amountEmpty_notAdded', () async {
      // arrange
      var restService = RESTService();

      // act
      var isAdded = await restService.addBalance("");

      // assert
      expect(isAdded, false);
    });

    test('addBalance_amountNoNumber_notAdded', () async {
      // arrange
      var restService = RESTService();

      // act
      var isAdded = await restService.addBalance("ABC");

      // assert
      expect(isAdded, false);
    });

    test('addBalance_amountValid_added', () async {
      // arrange
      // arrange
      var response = Response(
        statusCode: 200,
        requestOptions: RequestOptions(
          path: "",
        ),
      );

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));
      var restService = RESTService();

      // act
      var isAdded = await restService.addBalance("123");

      // assert
      expect(isAdded, true);
    });

    test(
        'getAvailiableStocks_availableStocksReceived_addedDataToUpstreamForEachElement',
        () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getAvailiableStocks();

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(3);
    });

    test('getAvailableStocks_notParsable_addedErrorDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": "3",
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getAvailiableStocks();
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getUserAssets_assetsReceived_addedDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "tokenAmmount": 3,
                  "symbol": "test",
                  "currentValue": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "_id": "3",
                },
                {
                  "tokenAmmount": 3,
                  "symbol": "test",
                  "currentValue": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "_id": "3",
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getUserAssets();

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getUserAssets_notParsable_addedErrorDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": "3",
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getUserAssets();
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getUserAssetHistory_assetHistoryReceived_addedDataToUpstream',
        () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "tokenAmmount": 3,
                  "symbol": "test",
                  "currentValue": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "_id": "3",
                },
                {
                  "tokenAmmount": 3,
                  "symbol": "test",
                  "currentValue": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "_id": "3",
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getUserAssetsHistory();

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getUserAssetHistory_notParsable_addedErrorDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": "3",
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getUserAssetsHistory();
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getUserBalanceHistory_balanceHistoryReceived_addedDataToUpstream',
        () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "reference": "3",
                  "uid": "test",
                  "newBalance": 3,
                  "oldBalance": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "type": "3",
                  "userId": "3",
                  "transactionId": "3",
                },
                {
                  "reference": "3",
                  "uid": "test",
                  "newBalance": 3,
                  "oldBalance": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "type": "3",
                  "userId": "3",
                  "transactionId": "3",
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getUserBalanceHistory();

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getUserBalanceHistory_notParsable_addedErrorDataToUpstream',
        () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": "3",
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getUserBalanceHistory();
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getBalance_balanceReceived_addedDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "item": {
                "reference": "3",
                "uid": "test",
                "newBalance": 3,
                "oldBalance": 3,
                "time": DateTime.now().toString(),
                "difference": 3,
                "type": "3",
                "userId": "3",
                "transactionId": "3",
              }
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      await restService.getBalance();

      // assert
      verify(dataHandler.addToDataUpstream(any, any)).called(1);
    });

    test('getBalance_notParsable_addedErrorDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": "3",
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var dataHandler = locator<DataHandler>() as MockDataHandler;
      when(dataHandler.addToDataUpstream(any, any)).thenReturn(null);

      var restService = RESTService();

      // act
      try {
        await restService.getBalance();
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      verify(dataHandler.addErrorToDataUpstream(any, any)).called(1);
    });

    test('getAssetsForSymbol_assetsReceived_addedDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "tokenAmmount": 3,
                  "symbol": "test",
                  "currentValue": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "_id": "3",
                },
                {
                  "tokenAmmount": 3,
                  "symbol": "test",
                  "currentValue": 3,
                  "time": DateTime.now().toString(),
                  "difference": 3,
                  "_id": "3",
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var restService = RESTService();

      // act
      var assets = await restService.getAssetForSymbol("AAPL");

      // assert
      expect(assets.length, 2);
    });

    test('getAssetsForSymbol_notParsable_addedErrorDataToUpstream', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ),
          data: {
            "body": {
              "items": [
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": 3,
                  "displayColor": null,
                },
                {
                  "assetType": "test",
                  "symbol": "test",
                  "displayName": "test",
                  "imageUrl": "test",
                  "description": "test",
                  "publicSentimentIndex": "3",
                  "displayColor": null,
                }
              ]
            }
          });

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var restService = RESTService();

      List<UserassetDatapoint> assets = [];
      // act
      try {
        assets = await restService.getAssetForSymbol("AAPL");
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      expect(assets.length, 0);
    });

    test('buyAsset_boughtSuccessfully_returnsTrue', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ));

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.post(any, data: anyNamed("data")))
          .thenAnswer((realInvocation) => Future.value(response));

      var restService = RESTService();

      // act
      var shouldBeTrue = await restService.buyAsset("AAPL", 2);

      // assert
      expect(shouldBeTrue, true);
    });

    test('buyAsset_notSuccessful_returnsFalse', () async {
      // arrange
      var response = Response(
          statusCode: 400,
          requestOptions: RequestOptions(
            path: "",
          ));

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var restService = RESTService();

      bool shouldBeFalse = false;
      // act
      try {
        shouldBeFalse = await restService.buyAsset("AAPL", 2);
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      expect(shouldBeFalse, false);
    });

    test('sellAsset_soldSuccessfully_returnsTrue', () async {
      // arrange
      var response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "",
          ));

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.post(any, data: anyNamed("data")))
          .thenAnswer((realInvocation) => Future.value(response));

      var restService = RESTService();

      // act
      var shouldBeTrue = await restService.sellAsset("AAPL", 2);

      // assert
      expect(shouldBeTrue, true);
    });

    test('sellAsset_notSuccessful_returnsFalse', () async {
      // arrange
      var response = Response(
          statusCode: 400,
          requestOptions: RequestOptions(
            path: "",
          ));

      var dioProvider = locator<DioHandler>() as MockDioHandler;
      when(dioProvider.get(any))
          .thenAnswer((realInvocation) => Future.value(response));

      var restService = RESTService();

      bool shouldBeFalse = false;
      // act
      try {
        shouldBeFalse = await restService.sellAsset("AAPL", 2);
      } catch (e) {
        print("Threw error as expected");
      }

      // assert
      expect(shouldBeFalse, false);
    });
  });
}
