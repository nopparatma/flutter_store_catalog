import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_master_label_location_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_master_label_location_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class SchematicService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Schematic';

  Future<GetMasterLabelLocationRs> getMasterLabelLocation(GetMasterLabelLocationRq rq) async {
    return await post(
      '${appConfig.labelApiServerUrl}/$controllerName/GetMasterLabelLocationRs',
      rq.toJson(),
      (data) => GetMasterLabelLocationRs.fromJson(data),
    );
  }
}
