import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class ProductKnowledgeService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/ProductKnowledge';

  Future<GetProductKnowledgeRs> getProductKnowledge(GetProductKnowledgeRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/GetProductKnowledge',
      rq.toJson(),
      (data) => GetProductKnowledgeRs.fromJson(data),
    );
  }

  Future<String> getProductKnowledgeHTMLContent(String knowledgeId) async {
    return await getBody('${appConfig.salesGuideApiServerUrl}/$controllerName/GetProductKnowledgeHTMLContent/$knowledgeId');
  }
}
