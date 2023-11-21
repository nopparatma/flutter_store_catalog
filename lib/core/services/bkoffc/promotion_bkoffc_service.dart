import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rs.dart';

import 'base_backoffice_webapi_service.dart';

class PromotionBkoffcService extends BaseBackOfficeWebApiService {
  static const String controllerName = 'promotion';
  var appConfig = AppConfig.instance;

  Future<SearchPromotionRs> searchPromotion(AppSession appSession, SearchPromotionRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/searchPromotion',
      rq.toJson(),
      (data) => SearchPromotionRs.fromJson(data),
    );
  }

  Future<GetPromotionRs> getPromotion(AppSession appSession, GetPromotionRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getPromotion',
      rq.toJson(),
          (data) => GetPromotionRs.fromJson(data),
    );
  }
}
