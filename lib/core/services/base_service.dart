import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../app_logger.dart';
import 'logging_interceptor.dart';

abstract class BaseService {
  var log = AppLogger();

  var dio = Dio(BaseOptions(contentType: Headers.jsonContentType, responseType: ResponseType.json, headers: {Headers.acceptHeader: Headers.jsonContentType}))..interceptors.add(LoggingInterceptors());

  Future<bool> existsUrl(String url) async {
    try {
      var response = await dio.head(url);
      if (response.statusCode == 200) return true;
    } catch (e) {
      if (e is DioError && e.response != null) {
        return true;
      }
    }
    return false;
  }

  Future<String> getBody(String url) async {
    var response = await http.get(url);
    if (response.statusCode == 200)  return utf8.decode(response.bodyBytes);
    return '';
  }
}
