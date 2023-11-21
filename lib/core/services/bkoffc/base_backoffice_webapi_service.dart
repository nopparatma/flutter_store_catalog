import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/services/base_service.dart';

abstract class BaseBackOfficeWebApiService extends BaseService {
  var appConfig = AppConfig.instance;

  Future post(String url, dynamic data, Function(dynamic data) returnCallback) async {
    var response = await dio.post(url, data: data);
    dynamic returnObj = returnCallback(response.data);

    if (returnObj is BaseBackOfficeWebApiRs) {
      BaseBackOfficeWebApiRs baseBackOfficeWebApiRs = returnObj;
      if (baseBackOfficeWebApiRs.status == null) {
        throw ErrorWebApiException('rsStatus is null', url, returnObj);
      }
      if (baseBackOfficeWebApiRs.status == 'E') {
        throw ErrorWebApiException('[BKOFFICE] : ${baseBackOfficeWebApiRs.message}', url, returnObj);
      }
    }

    return returnObj;
  }
}
