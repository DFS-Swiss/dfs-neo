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

  Future<dynamic> listSymbols() async {
    final response = await dio.get("/stockdata/list");
    return response;
  }

  Future<List<StockdataDatapoint>> getStockdata(
      String symbol, StockdataInterval interval) async {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, Map<StockdataInterval, List<StockdataDatapoint>>>>
      getStockdataBulk(StockdataBulkFetchRequest request) async {
    print("Performing bulk query");
    //try {
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
    //} catch (e) {
    //  rethrow;
    //}
  }

  Future<UserModel> getUserData() async {
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
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "user", "value": e});
      rethrow;
    }
  }

  Future<StockdataDocument> getStockInfo(String symbol) async {
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
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "symbol/$symbol", "value": e});
      rethrow;
    }
  }

  Future<List<StockdataDocument>> getAvailiableStocks() async {
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
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "symbols", "value": e});
      rethrow;
    }
  }

  Future<List<UserassetDatapoint>> getUserAssets() async {
    try {
      final response = await dio.get("/user/assets");
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
          {"key": "investments", "value": data},
        );
        return data;
      } else {
        throw "Unknown case: ${response.toString()}";
      }
    } catch (e) {
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "investments", "value": e});
      rethrow;
    }
  }

  Future<List<UserassetDatapoint>> getUserAssetsHistory(
      {StockdataInterval? interval}) async {
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
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "investments/history", "value": e});
      rethrow;
    }
  }

  Future<List<UserBalanceDatapoint>> getUserBalanceHistory(
      {StockdataInterval? interval}) async {
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
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "balance/history", "value": e});
      rethrow;
    }
  }

  Future<UserBalanceDatapoint> getBalance() async {
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
      DataService.getInstance()
          .dataUpdateStream
          .addError({"key": "balance", "value": e});
      rethrow;
    }
  }
}
