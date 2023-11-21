import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/cross_sell_item_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/cross_sell_item_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/similar_item_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/similar_item_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class ArticleService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Article';

  Future<SimilarItemRs> similarItem(SimilarItemRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/SimilarItem',
      rq.toJson(),
      (data) => SimilarItemRs.fromJson(data),
    );
  }

  Future<CrossSellItemRs> crossSellItem(CrossSellItemRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/CrossSellItem',
      rq.toJson(),
      (data) => CrossSellItemRs.fromJson(data),
    );
  }

  Future<GetProductGuideRs> getProductGuide(GetProductGuideRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/GetProductGuide',
      rq.toJson(),
      (data) => GetProductGuideRs.fromJson(data),
    );
  }
}
