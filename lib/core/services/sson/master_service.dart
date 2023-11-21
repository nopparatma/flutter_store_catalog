import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/sson/get_config_rq.dart';
import 'package:flutter_store_catalog/core/models/sson/get_config_rs.dart';

import '../base_dotnet_webapi_service.dart';

class MasterService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Master';

  Future<GetConfigRs> getConfigRq(GetConfigRq rq) async {
    return await postForward(
      '${appConfig.ssonApiServerUrl}/$controllerName/GetConfig',
      rq.toJson(),
          (data) => GetConfigRs.fromJson(data),
    );
  }
}
