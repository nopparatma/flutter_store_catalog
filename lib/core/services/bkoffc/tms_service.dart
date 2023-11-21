import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_gis_data_source_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_gis_data_source_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_village_condo_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_village_condo_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/base_backoffice_webapi_service.dart';

class TMSService extends BaseBackOfficeWebApiService {
  static const String controllerName = 'tms';

  Future<GetGisDataSourceRs> getGisDataSource(AppSession appSession, GetGisDataSourceRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getGisDataSource',
      rq.toJson(),
          (data) => GetGisDataSourceRs.fromJson(data),
    );
  }

  Future<GetMasterVillageCondoRs> getMasterVillageCondo(AppSession appSession, GetMasterVillageCondoRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getMasterVillageCondo',
      rq.toJson(),
          (data) => GetMasterVillageCondoRs.fromJson(data),
    );
  }
}