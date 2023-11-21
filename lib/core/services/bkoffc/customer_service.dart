import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_billto_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_billto_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_shipto_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_shipto_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_soldto_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_soldto_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/base_backoffice_webapi_service.dart';

class CustomerService extends BaseBackOfficeWebApiService {
  static const String controllerName = 'customer';

  Future<SearchCustomerRs> searchCustomer(AppSession appSession, SearchCustomerRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/searchCustomer',
      rq.toJson(),
      (data) => SearchCustomerRs.fromJson(data),
    );
  }

  Future<SearchCustomerByOidRs> searchCustomerByOid(AppSession appSession, SearchCustomerByOidRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getCustomerByOid',
      rq.toJson(),
      (data) => SearchCustomerByOidRs.fromJson(data),
    );
  }

  Future<CreateShiptoCustomerRs> createShiptoCustomer(AppSession appSession, CreateShiptoCustomerRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/createShipToCustomer',
      rq.toJson(),
      (data) => CreateShiptoCustomerRs.fromJson(data),
    );
  }

  Future<CreateBillToCustomerRs> createBillToCustomer(AppSession appSession, CreateBillToCustomerRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/createBillToCustomer',
      rq.toJson(),
      (data) => CreateBillToCustomerRs.fromJson(data),
    );
  }

  Future<CreateSoldToCustomerRs> createSoldToCustomer(AppSession appSession, CreateSoldToCustomerRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/createSoldToCustomer',
      rq.toJson(),
      (data) => CreateSoldToCustomerRs.fromJson(data),
    );
  }

  // Future<GetCustomerMapRs> getCustomerMap(AppSession appSession, GetCustomerMapRq rq) async {
  //   return await post(
  //     '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getCustomerMap',
  //     rq.toJson(),
  //     (data) => GetCustomerMapRs.fromJson(data),
  //   );
  // }
}
