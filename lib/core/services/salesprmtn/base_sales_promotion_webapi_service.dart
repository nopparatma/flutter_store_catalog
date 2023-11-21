import 'package:flutter_store_catalog/core/models/salesprmtn/base_sales_promotion_webapi_rs.dart';

import '../../app_exception.dart';
import '../base_service.dart';

abstract class BaseSalesPromotionWebApiService extends BaseService {
  Future post(String url, dynamic data, Function(dynamic data) returnCallback) async {
    var response = await dio.post(url, data: data);
    dynamic returnObj = returnCallback(response.data);

    if (returnObj is BaseSalesPromotionWebApiRs) {
      BaseSalesPromotionWebApiRs baseSalesPromotionWebApiRs = returnObj;
      if (baseSalesPromotionWebApiRs.rsStatus == null) {
        throw ErrorWebApiException('rsStatus is null', url, returnObj);
      }
      if (baseSalesPromotionWebApiRs.rsStatus == 'E') {
        throw ErrorWebApiException('[SALESPRMTN] : ${baseSalesPromotionWebApiRs.rsMsgDesc}', url, returnObj);
      }
    }

    return returnObj;
  }
}
