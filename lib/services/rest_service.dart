import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dfs_sdk/api.dart';
import 'package:neo/models/stockdata_datapoint.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/services/websocket/websocket_service.dart';
import 'package:neo/types/stockdata_interval_enum.dart';

const restApiBaseUrl = "https://rest.dfs-api.ch/v1";

class RESTService extends ChangeNotifier {
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
    DataService.getInstance().registerUserDataHandler("user", getUserData);
  }

  static RESTService getInstance() {
    return _instance ??= RESTService._();
  }

  Future<String> _getCurrentApiKey() async {
    return AuthenticationService.getInstance().getCurrentApiKey();
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
      rethrow;
    }
  }
}
