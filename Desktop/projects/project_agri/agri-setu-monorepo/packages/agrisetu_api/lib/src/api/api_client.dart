import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  static const String baseUrlAndroid =
      'http://172.16.88.67:8000'; // Physical Device
  static const String baseUrlWeb = 'http://localhost:8000';

  ApiClient({Dio? dio, String? baseUrl})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? baseUrlAndroid,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  void setToken(String? token) {
    if (token == null) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Token $token';
    }
  }
}
