import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class PrivacyPolicyService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/PrivacyPolicy';

  Future<GetMasterConsentListRs> getMasterConsentList(GetMasterConsentListRq rq, String language) async {
    return await post(
      '${appConfig.pdpaApiServerUrl}/$controllerName/GetMasterConsentList',
      rq.toJson(),
      (data) => GetMasterConsentListRs.fromJson(data),
      headers: {'accept-language': language},
    );
  }
}
