import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_store_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_store_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/base_backoffice_webapi_service.dart';

class StockService extends BaseBackOfficeWebApiService {
  static const String controllerName = 'stock';

  Future<GetStockRs> getStock(AppSession appSession, GetStockRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getStock',
      rq.toJson(),
          (data) => GetStockRs.fromJson(data),
    );
  }

  Future<GetStockStoreRs> getStockStore(AppSession appSession, GetStockStoreRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getStockStore',
      rq.toJson(),
          (data) => GetStockStoreRs.fromJson(data),
    );
  }
}
