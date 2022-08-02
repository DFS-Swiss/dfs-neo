import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/types/api/stockdata_bulk_fetch_request.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

import '../models/user_balance_datapoint.dart';
import '../service_locator.dart';

const restApiBaseUrl = "https://rest.dfs-api.ch/v1";

class RESTService extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  static RESTService? _instance;
  late Dio dio;
  RESTService._() {
    dio = Dio(BaseOptions(baseUrl: restApiBaseUrl));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final key = await _getCurrentApiKey();
        options.headers["apiKey"] = key;
        handler.next(options);
      },
    ));
    DataService.getInstance().registerUserDataHandler("user", [getUserData]);
    DataService.getInstance().registerUserDataHandler(
        "investments", [getUserAssets, getUserAssetsHistory]);
    DataService.getInstance().registerUserDataHandler(
        "balances", [getUserBalanceHistory, getBalance]);
  }

  static RESTService getInstance() {
    return _instance ??= RESTService._();
  }

  Future<String> _getCurrentApiKey() async {
    return _authenticationService.getCurrentApiKey();
  }

  Future<List<StockdataDatapoint>> getStockdata(
      String symbol, StockdataInterval interval,
      {int retryCount = 0}) async {
    try {
      final response = await dio.get("/stockdata/$symbol?interval=$interval");
      List<StockdataDatapoint> data;
      try {
        final list = response.data["body"]["items"] as List<dynamic>;
        data = list
            .map((e) => StockdataDatapoint.fromMap(e))
            .toList()
            .cast<StockdataDatapoint>();
        print("mattis");
      } catch (e) {
        throw "Parsing error: ${e.toString()}";
      }
      //TODO: Add Stockdata service update function

      final Map<String, Map<StockdataInterval, List<StockdataDatapoint>>>
          serviceInput = {
        symbol: {interval: data}
      };
      StockdataService.getInstance().updateData(serviceInput);
      return data;
    } catch (e, stack) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getStockdata(symbol, interval, retryCount: retryCount + 1);
      }
      await bugsnag.notify(e, stack);
      rethrow;
    }
  }

  Future<Map<String, Map<StockdataInterval, List<StockdataDatapoint>>>>
      getStockdataBulk(StockdataBulkFetchRequest request,
          {int retryCount = 0}) async {
    print("Performing bulk query");
    try {
      final Map<String, Map<StockdataInterval, List<StockdataDatapoint>>> out =
          {};
      final response = await dio.post("/stockdata/bulk", data: request.toMap());
      //try {
      final data = (response.data["body"]["symbols"] as Map<String, dynamic>);
      for (var symbol in data.entries) {
        if (out[symbol.key] == null) {
          out[symbol.key] = {};
        }
        for (var interval in data[symbol.key]!.entries) {
          final mappedList = (data[symbol.key]![interval.key]! as List<dynamic>)
              .map((e) => StockdataDatapoint.fromMap(e))
              .toList();
          if (mappedList.length < 2) {
            await bugsnag.notify("Error in bulk fetch result", null);
            print("Error detected");
          }
          print(mappedList.length);
          out[symbol.key]![StockdataInterval.fromString(interval.key)] =
              mappedList;
        }
      }
      //} catch (e) {
      //throw "Parsing error: ${e.toString()}";
      //}
      StockdataService.getInstance().updateData(out);
      return out;
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getStockdataBulk(request, retryCount: retryCount + 1);
      }
      rethrow;
    }
  }

  Future<UserModel> getUserData({int retryCount = 0}) async {
    try {
      final response = await dio.get("/user");
      if (response.statusCode.toString().startsWith("2")) {
        UserModel data;
        try {
          data = UserModel.fromMap(response.data["body"]["item"]);
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "user", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getUserData(retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "user", "value": e});
      rethrow;
    }
  }

  Future<StockdataDocument> getStockInfo(String symbol,
      {int retryCount = 0}) async {
    try {
      final response = await dio.get("/stockdata/$symbol/info");
      if (response.statusCode.toString().startsWith("2")) {
        StockdataDocument data;
        try {
          data = StockdataDocument.fromMap(response.data["body"]["item"]);
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "symbol/$symbol", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getStockInfo(symbol, retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "symbol/$symbol", "value": e});
      rethrow;
    }
  }

  Future<List<StockdataDocument>> getStockInfoBulk(List<String> symbols,
      {int retryCount = 0}) async {
    try {
      final response = await dio.get("/stockdata/info?symbols=$symbols");
      if (response.statusCode.toString().startsWith("2")) {
        List<StockdataDocument> data;
        try {
          data = (response.data["body"]["items"] as List<dynamic>)
              .map((e) => StockdataDocument.fromMap(e))
              .toList();
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        for (var stockInfo in data) {
          DataService.getInstance().dataUpdateStream.add(
            {"key": "symbol/${stockInfo.symbol}", "value": stockInfo},
          );
        }

        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getStockInfoBulk(symbols, retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "symbols", "value": e});
      rethrow;
    }
  }

  Future<bool> addBalance(String amount) async {
    try {
      final response = await dio.get("/debug/addBalance?amount=$amount");
      if (response.statusCode.toString().startsWith("2")) {
        return true;
      } else if (response.statusCode.toString() == "401") {
        throw response;
      } else {
        return false;
      }
    } catch (e, stack) {
      await bugsnag.notify(e, stack);
      rethrow;
    }
  }

  Future<List<StockdataDocument>> getAvailiableStocks(
      {int retryCount = 0}) async {
    try {
      final response = await dio.get("/stockdata/");
      if (response.statusCode.toString().startsWith("2")) {
        List<StockdataDocument> data;

        try {
          data = (response.data["body"]["items"] as List<dynamic>)
              .map((e) => StockdataDocument.fromMap(e))
              .toList();
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "symbols", "value": data},
        );
        for (var stockInfo in data) {
          DataService.getInstance().dataUpdateStream.add(
            {"key": "symbol/${stockInfo.symbol}", "value": stockInfo},
          );
        }
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getAvailiableStocks(retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "symbols", "value": e});
      rethrow;
    }
  }

  Future<List<UserassetDatapoint>> getUserAssets({int retryCount = 0}) async {
    try {
      final response = await dio.get("/user/assets");
      if (response.statusCode.toString().startsWith("2")) {
        List<UserassetDatapoint> data;

        try {
          data = (response.data["body"]["items"] as List<dynamic>)
              .map((e) => UserassetDatapoint.fromMap(e))
              .toList()
            ..sort((a, b) => b.tokenAmmount.compareTo(a.tokenAmmount));
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "investments", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getUserAssets(retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "investments", "value": e});
      rethrow;
    }
  }

  Future<List<UserassetDatapoint>> getUserAssetsHistory(
      {StockdataInterval? interval, int retryCount = 0}) async {
    try {
      final response =
          await dio.get("/user/assets/history?interval=${interval ?? "all"}");
      if (response.statusCode.toString().startsWith("2")) {
        List<UserassetDatapoint> data;

        try {
          data = (response.data["body"]["items"] as List<dynamic>)
              .map((e) => UserassetDatapoint.fromMap(e))
              .toList();
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "investments/history", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getUserAssetsHistory(retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "investments/history", "value": e});
      rethrow;
    }
  }

  Future<List<UserBalanceDatapoint>> getUserBalanceHistory({
    StockdataInterval? interval,
    int retryCount = 0,
  }) async {
    try {
      final response =
          await dio.get("/user/balance/history?interval=${interval ?? "all"}");
      if (response.statusCode.toString().startsWith("2")) {
        List<UserBalanceDatapoint> data;

        try {
          data = (response.data["body"]["items"] as List<dynamic>)
              .map((e) => UserBalanceDatapoint.fromMap(e))
              .toList();
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "balance/history", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getUserBalanceHistory(retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "balance/history", "value": e});
      rethrow;
    }
  }

  Future<UserBalanceDatapoint> getBalance({int retryCount = 0}) async {
    try {
      final response = await dio.get("/user/balance");
      if (response.statusCode.toString().startsWith("2")) {
        UserBalanceDatapoint data;

        try {
          data = UserBalanceDatapoint.fromMap(response.data["body"]["item"]);
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        DataService.getInstance().dataUpdateStream.add(
          {"key": "balance", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getBalance(retryCount: retryCount + 1);
      }
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "balance", "value": e});
      rethrow;
    }
  }

  Future<List<UserassetDatapoint>> getAssetForSymbol(String symbol,
      {int retryCount = 0}) async {
    try {
      final response = await dio.get("/user/assets/$symbol");
      if (response.statusCode.toString().startsWith("2")) {
        List<UserassetDatapoint> data;

        try {
          data = (response.data["body"]["items"] as List<dynamic>)
              .map((e) => UserassetDatapoint.fromMap(e))
              .toList();
        } catch (e) {
          throw "Parsing error: ${e.toString()}";
        }
        return data;
      } else if (response.statusCode.toString() == "404") {
        throw "404";
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e, stack) {
      if (retryCount < 4) {
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        return getAssetForSymbol(symbol, retryCount: retryCount + 1);
      }
      await bugsnag.notify(e, stack);
      rethrow;
    }
  }

  Future<bool> buyAsset(String symbol, double amountInDollar) async {
    try {
      final response = await dio.post(
        "/assets/buy",
        data: {
          "symbol": symbol,
          "amountToSpend": amountInDollar,
        },
      );
      if (response.statusCode.toString().startsWith("2")) {
        return true;
      }
      if (response.statusCode == 400) {
        throw "Insuficient funds";
      }
      return false;
    } catch (e, stack) {
      if (e is DioError && e.response!.statusCode == 400) {
        rethrow;
      } else {
        await bugsnag.notify(e, stack);
        rethrow;
      }
    }
  }

  Future<bool> sellAsset(String symbol, double ammountOfTokensToSell) async {
    try {
      final response = await dio.post("/assets/sell", data: {
        "symbol": symbol,
        "ammountOfTokensToSell": ammountOfTokensToSell
      });
      if (response.statusCode.toString().startsWith("2")) {
        return true;
      }
      if (response.statusCode == 400) {
        throw "Insuficient token";
      }
      return false;
    } catch (e, stack) {
      await bugsnag.notify(e, stack);
      rethrow;
    }
  }
}
