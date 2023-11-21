import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class CheckListInformationService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/CheckListInfo';

  Future<GetCheckListInformationQuestionRs> getCheckListInformationQuestion(GetCheckListInformationQuestionRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/GetCheckListInformationQuestion',
      rq.toJson(),
          (data) => GetCheckListInformationQuestionRs.fromJson(data),
    );
  }

  Future<GetExcessProductRs> getExcessProduct(GetExcessProductRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/GetExcessProduct',
      rq.toJson(),
          (data) => GetExcessProductRs.fromJson(data),
    );
  }
}

