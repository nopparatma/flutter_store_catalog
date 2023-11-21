import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/sson/authenticate_rq.dart';
import 'package:flutter_store_catalog/core/models/sson/authenticate_rs.dart';
import 'package:flutter_store_catalog/core/models/sson/check_version_application_rq.dart';
import 'package:flutter_store_catalog/core/models/sson/check_version_application_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class AuthorizationService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Auth';

  Future<AuthenticateRs> authenticate(AuthenticateRq rq) async {
    return await post(
      '${appConfig.ssonApiServerUrl}/$controllerName/Login_V2',
      rq.toJson(),
      (data) => AuthenticateRs.fromJson(data),
    );
  }

  Future<CheckVersionApplicationRs> checkVersionApplication(CheckVersionApplicationRq rq) async {
    return await post(
      '${appConfig.ssonApiServerUrl}/$controllerName/CheckVersionApplication',
      rq.toJson(),
      (data) => CheckVersionApplicationRs.fromJson(data),
    );
  }
}
