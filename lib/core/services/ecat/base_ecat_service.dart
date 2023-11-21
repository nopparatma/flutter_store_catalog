import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

import '../../app_exception.dart';
import '../base_service.dart';

abstract class BaseECatService extends BaseService {
  var appConfig = AppConfig.instance;

  Future post(String url, dynamic data, Function(dynamic data) returnCallback) async {
    var response = await dio.post(url, data: data);
    dynamic returnObj = returnCallback(response.data);

    if (returnObj is BaseECatRs) {
      BaseECatRs baseECatRs = returnObj;
      if (baseECatRs.messageStatusRs == null) {
        throw ErrorWebApiException('messageStatusRs is null', url, returnObj);
      }

      if (baseECatRs.messageStatusRs.status == null) {
        throw ErrorWebApiException('rsStatus is null', url, returnObj);
      }
      if (baseECatRs.messageStatusRs.status == 'E') {
        throw ErrorWebApiException(baseECatRs.messageStatusRs.message, url, returnObj);
      }
    }

    return returnObj;
  }

  // Future postForward(String url, dynamic data, Function(dynamic data) returnCallback) async {
  //   String forwardUrl = '${appConfig.ecatApiServerUrl}/api/ECatalog/Forward?url=$url';
  //
  //   var response = await dio.post(forwardUrl, data: data);
  //   dynamic returnObj = returnCallback(response.data);
  //
  //   if (returnObj is BaseECatRs) {
  //     BaseECatRs baseECatRs = returnObj;
  //     if (baseECatRs.messageStatusRs == null) {
  //       throw ErrorWebApiException('messageStatusRs is null', url, returnObj);
  //     }
  //
  //     if (baseECatRs.messageStatusRs.status == null) {
  //       throw ErrorWebApiException('rsStatus is null', url, returnObj);
  //     }
  //     if (baseECatRs.messageStatusRs.status == 'E') {
  //       throw ErrorWebApiException(baseECatRs.messageStatusRs.message, url, returnObj);
  //     }
  //   }
  //
  //   return returnObj;
  // }
  //
  // Future postForwardProxy(String url, dynamic data, Function(dynamic data) returnCallback) async {
  //   String forwardUrl = '${appConfig.ecatApiServerUrl}/api/ECatalog/Forward?useProxy=Y&url=$url';
  //
  //   var response = await dio.post(forwardUrl, data: data);
  //   dynamic returnObj = returnCallback(response.data);
  //
  //   if (returnObj is BaseECatRs) {
  //     BaseECatRs baseECatRs = returnObj;
  //     if (baseECatRs.messageStatusRs == null) {
  //       throw ErrorWebApiException('messageStatusRs is null', url, returnObj);
  //     }
  //
  //     if (baseECatRs.messageStatusRs.status == null) {
  //       throw ErrorWebApiException('rsStatus is null', url, returnObj);
  //     }
  //     if (baseECatRs.messageStatusRs.status == 'E') {
  //       throw ErrorWebApiException(baseECatRs.messageStatusRs.message, url, returnObj);
  //     }
  //   }
  //
  //   return returnObj;
  // }
}
