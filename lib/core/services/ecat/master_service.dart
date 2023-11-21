import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/base_ecat_service.dart';

class MasterService extends BaseECatService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Master';

  Future<GetRoomCategoryRs> getRoomCategory(GetRoomCategoryRq rq) async {
    return await post(
      '${appConfig.ecatApiServerUrl}/$controllerName/GetRoomCategory',
      rq.toJson(),
      (data) => GetRoomCategoryRs.fromJson(data),
    );
  }
}
