import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_item_promotion_detail_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_item_promotion_detail_rs.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/base_sales_promotion_webapi_service.dart';

class PromotionService extends BaseSalesPromotionWebApiService {
  static const String controllerName = 'promotion';

  Future<CalculatePromotionCARs> calculatePromotionCA(AppSession appSession, CalculatePromotionCARq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$salesPrmtnContextApi/$controllerName/calculatePromotionCA',
      rq.toJson(),
      (data) => CalculatePromotionCARs.fromJson(data),
    );
  }

  Future<GetItemPromotionDetailRs> getItemPromotionDetail(AppSession appSession, GetItemPromotionDetailRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$salesPrmtnContextApi/$controllerName/getItemPromotionDetail',
      rq.toJson(),
          (data) => GetItemPromotionDetailRs.fromJson(data),
    );
  }
}
