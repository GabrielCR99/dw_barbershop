import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'interceptors/auth_interceptor.dart';

final class RestClient extends DioForNative {
  RestClient()
      : super(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 60),
            baseUrl: 'http://localhost:8080/',
          ),
        ) {
    interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      AuthInterceptor(),
    ]);
  }

  RestClient get auth => this..options.extra['DIO_AUTH_KEY'] = true;

  RestClient get unAuth => this..options.extra['DIO_AUTH_KEY'] = false;
}
