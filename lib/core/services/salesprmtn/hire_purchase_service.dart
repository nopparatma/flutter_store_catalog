import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rs.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/base_sales_promotion_webapi_service.dart';

class HirePurchaseService extends BaseSalesPromotionWebApiService {
  static const String controllerName = 'hirepurchase';

  Future<GetHirePurchasePromotionRs> getHirePurchasePromotion(AppSession appSession, GetHirePurchasePromotionRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$salesPrmtnContextApi/$controllerName/getHirePurchasePromotion',
      rq.toJson(),
      (data) => GetHirePurchasePromotionRs.fromJson(data),
    );
  }
}
