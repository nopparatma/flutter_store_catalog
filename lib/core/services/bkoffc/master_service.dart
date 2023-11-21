import 'package:flutter_store_catalog/core/models/bkoffc/get_address_paging_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_address_paging_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_address_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_address_rs.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_credit_card_image_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_credit_card_image_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_customer_titles_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_customer_titles_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_mng_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_mng_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_ds_conf_type_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_ds_conf_type_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_ds_time_group_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_ds_time_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_item_discount_condition_type_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_item_discount_condition_type_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_job_type_by_shippoint_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_job_type_by_shippoint_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_main_product_type_by_job_type_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_main_product_type_by_job_type_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mch_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mch_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_cr_card_range_id_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_cr_card_range_id_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_tender_group_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_tender_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_discount_condition_type_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_discount_condition_type_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_system_config_constant_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_system_config_constant_rs.dart';
import 'base_backoffice_webapi_service.dart';

class MasterService extends BaseBackOfficeWebApiService {
  static const String controllerName = 'master';

  Future<GetAddressRs> getAddress(AppSession appSession, GetAddressRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getAddress',
      rq.toJson(),
      (data) => GetAddressRs.fromJson(data),
    );
  }

  Future<GetMCHRs> getMCH(AppSession appSession, GetMCHRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getMCH',
      rq.toJson(),
      (data) => GetMCHRs.fromJson(data),
    );
  }

  Future<GetShippingPointRs> getShippingPoint(AppSession appSession, GetShippingPointRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getShippingPoint',
      rq.toJson(),
      (data) => GetShippingPointRs.fromJson(data),
    );
  }

  Future<GetDsTimeGroupRs> getTimeType(AppSession appSession, GetDsTimeGroupRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getTimeType',
      rq.toJson(),
      (data) => GetDsTimeGroupRs.fromJson(data),
    );
  }

  Future<GetMstMbrCardGroupRs> getDiscountCardGroup(AppSession appSession, GetMstMbrCardGroupRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getDiscountCardGroup',
      rq.toJson(),
      (data) => GetMstMbrCardGroupRs.fromJson(data),
    );
  }

  Future<GetMstMbrCardGroupRs> getRewardCardGroup(AppSession appSession, GetMstMbrCardGroupRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getRewardCardGroup',
      rq.toJson(),
      (data) => GetMstMbrCardGroupRs.fromJson(data),
    );
  }

  Future<GetMstTenderGroupRs> getMasterTenderGroup(AppSession appSession, GetMstTenderGroupRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getTenderGroup',
      rq.toJson(),
      (data) => GetMstTenderGroupRs.fromJson(data),
    );
  }

  Future<GetCreditCardImageRs> getCreditCardImage(AppSession appSession, GetCreditCardImageRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getCreditCardImage',
      rq.toJson(),
      (data) => GetCreditCardImageRs.fromJson(data),
    );
  }

  Future<GetDsConfTypeRs> getConfType(AppSession appSession, GetDsConfTypeRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getConfType',
      rq.toJson(),
      (data) => GetDsConfTypeRs.fromJson(data),
    );
  }

  Future<GetItemDiscountConditionTypeRs> getItemDiscountConditionType(AppSession appSession, GetItemDiscountConditionTypeRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getItemDiscountConditionType',
      rq.toJson(),
      (data) => GetItemDiscountConditionTypeRs.fromJson(data),
    );
  }

  Future<GetStoreDiscountConditionTypeRs> getStoreDiscountConditionType(AppSession appSession, GetStoreDiscountConditionTypeRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getStoreDiscountConditionType',
      rq.toJson(),
      (data) => GetStoreDiscountConditionTypeRs.fromJson(data),
    );
  }

  Future<GetDeliveryMngRs> getDeliveryMng(AppSession appSession, GetDeliveryMngRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getDeliveryMngs',
      rq.toJson(),
      (data) => GetDeliveryMngRs.fromJson(data),
    );
  }

  Future<GetMainProductTypeByJobTypeRs> getMainProductTypeByJobType(AppSession appSession, GetMainProductTypeByJobTypeRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getMainProductTypeByJobType',
      rq.toJson(),
      (data) => GetMainProductTypeByJobTypeRs.fromJson(data),
    );
  }

  Future<GetMstBankRs> getMstBank(AppSession appSession, GetMstBankRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getMstBank',
      rq.toJson(),
      (data) => GetMstBankRs.fromJson(data),
    );
  }

  Future<GetSystemConfigConstantRs> getSystemConfigConstant(AppSession appSession, GetSystemConfigConstantRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getSystemConfigConstant',
      rq.toJson(),
      (data) => GetSystemConfigConstantRs.fromJson(data),
    );
  }

  Future<GetMstCrCardRangeIdRs> getMstCreditCardRangeId(AppSession appSession, GetMstCrCardRangeIdRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getMstCreditCardRangeId',
      rq.toJson(),
      (data) => GetMstCrCardRangeIdRs.fromJson(data),
    );
  }

  Future<GetJobTypeByShippointRs> getJobTypeByShippoint(AppSession appSession, GetJobTypeByShippointRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getJobTypeByShippoint',
      rq.toJson(),
      (data) => GetJobTypeByShippointRs.fromJson(data),
    );
  }

  Future<GetAddressPagingRs> getAddressPaging(AppSession appSession, GetAddressPagingRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getAddressPaging',
      rq.toJson(),
          (data) => GetAddressPagingRs.fromJson(data),
    );
  }

  Future<GetCustomerTitlesRs> getCustomerTitles(AppSession appSession, GetCustomerTitlesRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getCustomerTitles',
      rq.toJson(),
          (data) => GetCustomerTitlesRs.fromJson(data),
    );
  }
}
