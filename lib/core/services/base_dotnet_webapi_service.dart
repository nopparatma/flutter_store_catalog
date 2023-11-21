import 'package:dio/dio.dart';
import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';

import '../app_exception.dart';
import 'base_service.dart';

abstract class BaseDotnetWebApiService extends BaseService {
  var appConfig = AppConfig.instance;

  Future post(String url, dynamic data, Function(dynamic data) returnCallback, {Map<String, dynamic> headers}) async {
    var response = await dio.post(url, data: data, options: Options(headers: headers));
    dynamic returnObj = returnCallback(response.data);

    if (returnObj is BaseDotnetWebApiRs) {
      BaseDotnetWebApiRs baseDotnetWebApiRs = returnObj;
      if (baseDotnetWebApiRs.messageStatusRs == null) {
        throw ErrorWebApiException('messageStatusRs is null', url, returnObj);
      }
      if (baseDotnetWebApiRs.messageStatusRs.status == 'E') {
        throw ErrorWebApiException(baseDotnetWebApiRs.messageStatusRs.message, url, returnObj);
      }
      if (baseDotnetWebApiRs.messageStatusRs.status == 'W') {
        throw WarningWebApiException(baseDotnetWebApiRs.messageStatusRs.message, url, returnObj);
      }
    }

    return returnObj;
  }

  Future postForward(String url, dynamic data, Function(dynamic data) returnCallback) async {
    String forwardUrl = '${appConfig.ecatApiServerUrl}/api/ECatalog/Forward?url=$url';

    var response = await dio.post(forwardUrl, data: data);
    dynamic returnObj = returnCallback(response.data);

    if (returnObj is BaseDotnetWebApiRs) {
      BaseDotnetWebApiRs baseDotnetWebApiRs = returnObj;
      if (baseDotnetWebApiRs.messageStatusRs == null) {
        throw ErrorWebApiException('messageStatusRs is null', url, returnObj);
      }
      if (baseDotnetWebApiRs.messageStatusRs.status == 'E') {
        throw ErrorWebApiException(baseDotnetWebApiRs.messageStatusRs.message, url, returnObj);
      }
      if (baseDotnetWebApiRs.messageStatusRs.status == 'W') {
        throw WarningWebApiException(baseDotnetWebApiRs.messageStatusRs.message, url, returnObj);
      }
    }

    return returnObj;
  }
}
