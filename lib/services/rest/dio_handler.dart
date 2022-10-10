import 'package:dio/dio.dart';

import '../../service_locator.dart';
import '../authentication/authentication_service.dart';

class DioHandler {
  static const restApiBaseUrl = "https://rest.dfs-api.ch/v1";

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  late Dio _dio;
  DioHandler() {
    _dio = Dio(BaseOptions(baseUrl: restApiBaseUrl));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final key = await _authenticationService.getCurrentApiKey();
        options.headers["apiKey"] = key;
        handler.next(options);
      },
    ));
  }

  Future<Response<dynamic>> post(String s, {required Map<String, dynamic> data}) async {
    return await _dio.post(s, data:  data);
  }

  Future<Response<dynamic>> get(String s) async {
    return await _dio.get(s);
  }
}
