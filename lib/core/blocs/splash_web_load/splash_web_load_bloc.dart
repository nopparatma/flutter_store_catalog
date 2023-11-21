import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
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
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mch_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mch_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_tender_group_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_tender_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_discount_condition_type_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_discount_condition_type_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_info_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_info_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_system_config_constant_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_system_config_constant_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/master_service.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_user_profile_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_user_profile_rs.dart';
import 'package:flutter_store_catalog/core/models/user_profile.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/privacy_policy_service.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/app_session_util.dart';
import 'package:flutter_store_catalog/core/utilities/shared_pref_util.dart';
import 'package:collection/collection.dart' as collection;
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';

import '../../get_it.dart';

part 'splash_web_load_event.dart';

part 'splash_web_load_state.dart';

class SplashWebLoadBloc extends Bloc<SplashWebLoadEvent, SplashWebLoadState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final MasterService _masterService = getIt<MasterService>();
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();

  final ApplicationBloc applicationBloc;
  static const String SHARED_PREF_KEY_TOKEN = "TOKEN";

  SplashWebLoadBloc(this.applicationBloc);

  @override
  SplashWebLoadState get initialState => InitialSplashWebLoadState();

  @override
  Stream<SplashWebLoadState> mapEventToState(SplashWebLoadEvent event) async* {
    if (event is SplashWebLoadInitEvent) {
      try {
        yield LoadingSplashWebLoadState('USER');

        GetUserProfileRq rq = GetUserProfileRq();
        rq.tokenId = event.token;
        // rq.tokenId = '8bf9b027-285d-49dc-8505-3315790827c0'; //for S015
        // rq.tokenId = '30f7340f-5294-4d0e-872b-56d27e78df5a'; //for S001
        // rq.tokenId = '3ce21663-728e-4734-bcf0-779f68c36a58'; //for PRD
        if (StringUtil.isNullOrEmpty(rq.tokenId)) { // case refresh use old token
          rq.tokenId = await SharedPrefUtil.read(SHARED_PREF_KEY_TOKEN);
        }
        if (StringUtil.isNullOrEmpty(rq.tokenId)) {
          throw 'invalid token';
        }

        var futureGetUserProfileRs = _categoryService.getUserProfile(rq);
        GetUserProfileRs rs = await futureGetUserProfileRs;

        UserProfile userProfile = UserProfile(
          empId: rs.empId,
          empNo: rs.empNo,
          empName: rs.empName,
          groupNo: rs.groupNo,
          groupDesc: rs.groupDesc,
          companyCode: rs.companyCode,
          storeId: rs.storeNo,
          storeDesc: rs.storeDesc,
          storeIP: rs.storeIP,
        );

        SharedPrefUtil.save(SHARED_PREF_KEY_TOKEN, rq.tokenId);

        AppSession appSession = new AppSession();
        appSession.userProfile = userProfile;

        yield LoadingSplashWebLoadState('MASTER');

        await initialData(appSession);

        yield SuccessSplashWebLoadState();
      } catch (error, stackTrace) {
        yield ErrorSplashWebLoadState(AppException(error, stackTrace: stackTrace));
      }
    }
  }

  initialData(AppSession appSession) async {

    GetStoreInfoRq getStoreInfoRq = GetStoreInfoRq();
    getStoreInfoRq.storeId = appSession.userProfile.storeId;
    var futureGetStoreInfoRs = _saleOrderService.getStoreInfo(appSession, getStoreInfoRq);

    GetSystemConfigConstantRq getSystemConfigConstantRq = new GetSystemConfigConstantRq();
    var futureGetSystemConfigConstantRs = _masterService.getSystemConfigConstant(appSession, getSystemConfigConstantRq);

    GetDsTimeGroupRq getDsTimeGroupRq = GetDsTimeGroupRq();
    var futureGetDsTimeGroupRs = _masterService.getTimeType(appSession, getDsTimeGroupRq);

    // load by shared pref
    // var futureGetShippingPointRs = loadShippingPoint(appSession);
    // var futureGetMCHRs = loadMCH(appSession);
    // var futureGetRwdCardGroupRs = loadRewardCardGroup(appSession);
    var futureGetDiscountCardGroupRs = loadDiscountCardGroup(appSession);
    // var futureGetMstTenderGroupRs = loadTenderGroup(appSession);
    // var futureGetDsConfTypeRs = loadConfType(appSession);
    // var futureGetDsTimeGroupRs = loadTimeType(appSession);
    // var futureGetStoreDiscountConditionTypeRs = loadStoreDiscountConditionType(appSession);
    // var futureGetItemDiscountConditionTypeRs = loadItemDiscountConditionType(appSession);
    // var futureGetCreditCardImageRs = loadCreditCardImage(appSession);
    // var futureGetDeliveryMngRs = loadDeliveryMng(appSession);
    var futureGetMstBankRs = loadMstBank(appSession);
    var futureGetCustomerTitlesRs = loadCustomerTitle(appSession);

    await Future.wait([
      futureGetStoreInfoRs,
      futureGetSystemConfigConstantRs,
      // futureGetShippingPointRs,
      // futureGetMCHRs,
      // futureGetRwdCardGroupRs,
      futureGetDiscountCardGroupRs,
      // futureGetMstTenderGroupRs,
      // futureGetDsConfTypeRs,
      futureGetDsTimeGroupRs,
      // futureGetStoreDiscountConditionTypeRs,
      // futureGetItemDiscountConditionTypeRs,
      // futureGetCreditCardImageRs,
      // futureGetDeliveryMngRs,
      futureGetCustomerTitlesRs,
      futureGetMstBankRs,
    ], eagerError: true);


    GetStoreInfoRs getStoreInfoRs = await futureGetStoreInfoRs;

    GetSystemConfigConstantRs getSystemConfigConstantRs = await futureGetSystemConfigConstantRs;

    GetDsTimeGroupRs getDsTimeGroupRs = await futureGetDsTimeGroupRs;

    // GetShippingPointRs getShippingPointRs = await futureGetShippingPointRs;
    // GetMCHRs getMCHRs = await futureGetMCHRs;
    // GetMstMbrCardGroupRs getRwdCardGroupRs = await futureGetRwdCardGroupRs;
    GetMstMbrCardGroupRs getDiscountCardGroupRs = await futureGetDiscountCardGroupRs;
    // GetMstTenderGroupRs getMstTenderGroupRs = await futureGetMstTenderGroupRs;
    // GetDsConfTypeRs getDsConfTypeRs = await futureGetDsConfTypeRs;
    // GetDsTimeGroupRs getDsTimeGroupRs = await futureGetDsTimeGroupRs;
    // GetStoreDiscountConditionTypeRs getStoreDiscountConditionTypeRs = await futureGetStoreDiscountConditionTypeRs;
    // GetItemDiscountConditionTypeRs getItemDiscountConditionTypeRs = await futureGetItemDiscountConditionTypeRs;
    // GetCreditCardImageRs getCreditCardImageRs = await futureGetCreditCardImageRs;
    // GetDeliveryMngRs getDeliveryMngRs = await futureGetDeliveryMngRs;
    GetCustomerTitlesRs getCustomerTitlesRs = await futureGetCustomerTitlesRs;
    GetMstBankRs getMstBankRs = await futureGetMstBankRs;

    appSession.transactionDateTime = getStoreInfoRs.transactionDate;

    Map mapSysCfg = new Map();
    if (getSystemConfigConstantRs != null && getSystemConfigConstantRs.systemConfigurations != null && getSystemConfigConstantRs.systemConfigurations.length > 0) {
      for (SystemConfiguration cfgBo in getSystemConfigConstantRs.systemConfigurations) {
        mapSysCfg.putIfAbsent(cfgBo.key, () => cfgBo.value);
      }
    }


    await AppSessionUtil.save(appSession);

    applicationBloc.add(ApplicationUpdateStateModelEvent(
      appSession: appSession,
      // getShippingPointRs: getShippingPointRs,
      // getMCHRs: getMCHRs,
      // getMstRewardCardGroup: getRwdCardGroupRs,
      getMstDiscountCardGroup: getDiscountCardGroupRs,
      // getMstTenderGroupRs: getMstTenderGroupRs,
      // getDsConfTypeRs: getDsConfTypeRs,
      getDsTimeGroupRs: getDsTimeGroupRs,
      // getStoreDiscountConditionTypeRs: getStoreDiscountConditionTypeRs,
      // getItemDiscountConditionTypeRs: getItemDiscountConditionTypeRs,
      // getCreditCardImageRs: getCreditCardImageRs,
      // getDeliveryMngRs: getDeliveryMngRs,
      getCustomerTitlesRs: getCustomerTitlesRs,
      getMstBankRs: getMstBankRs,
      sysCfgMap: mapSysCfg,
    ));
  }

  Future<GetShippingPointRs> loadShippingPoint(AppSession appSession) async {
    const String DATA_KEY = "SHIPPING_POINT";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetShippingPointRs localRs;
      try {
        localRs = GetShippingPointRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetShippingPointRq rq = GetShippingPointRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetShippingPointRs rs = await _masterService.getShippingPoint(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }

      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetMCHRs> loadMCH(AppSession appSession) async {
    const String DATA_KEY = "MCH";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetMCHRs localRs;
      try {
        localRs = GetMCHRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetMCHRq rq = GetMCHRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetMCHRs rs = await _masterService.getMCH(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetCustomerTitlesRs> loadCustomerTitle(AppSession appSession) async {
    const String DATA_KEY = "CUSTOMER_TITLE";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetCustomerTitlesRs localRs;
      try {
        localRs = GetCustomerTitlesRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetCustomerTitlesRq rq = GetCustomerTitlesRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetCustomerTitlesRs rs = await _masterService.getCustomerTitles(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetMstMbrCardGroupRs> loadRewardCardGroup(AppSession appSession) async {
    const String DATA_KEY = "REWARD_CARD_GROUP";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetMstMbrCardGroupRs localRs;
      try {
        localRs = GetMstMbrCardGroupRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetMstMbrCardGroupRq rq = GetMstMbrCardGroupRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetMstMbrCardGroupRs rs = await _masterService.getRewardCardGroup(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetMstMbrCardGroupRs> loadDiscountCardGroup(AppSession appSession) async {
    const String DATA_KEY = "DISCOUNT_CARD_GROUP";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetMstMbrCardGroupRs localRs;
      try {
        localRs = GetMstMbrCardGroupRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetMstMbrCardGroupRq rq = GetMstMbrCardGroupRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetMstMbrCardGroupRs rs = await _masterService.getDiscountCardGroup(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetMstTenderGroupRs> loadTenderGroup(AppSession appSession) async {
    const String DATA_KEY = "TENDER_GROUP";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetMstTenderGroupRs localRs;
      try {
        localRs = GetMstTenderGroupRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetMstTenderGroupRq rq = GetMstTenderGroupRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetMstTenderGroupRs rs = await _masterService.getMasterTenderGroup(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetDsConfTypeRs> loadConfType(AppSession appSession) async {
    const String DATA_KEY = "CONF_TYPE";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetDsConfTypeRs localRs;
      try {
        localRs = GetDsConfTypeRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetDsConfTypeRq rq = GetDsConfTypeRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetDsConfTypeRs rs = await _masterService.getConfType(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetDsTimeGroupRs> loadTimeType(AppSession appSession) async {
    const String DATA_KEY = "TIME_TYPE";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetDsTimeGroupRs localRs;
      try {
        localRs = GetDsTimeGroupRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetDsTimeGroupRq rq = GetDsTimeGroupRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetDsTimeGroupRs rs = await _masterService.getTimeType(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetStoreDiscountConditionTypeRs> loadStoreDiscountConditionType(AppSession appSession) async {
    const String DATA_KEY = "STORE_DISCOUNT_COND_TYPE";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetStoreDiscountConditionTypeRs localRs;
      try {
        localRs = GetStoreDiscountConditionTypeRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetStoreDiscountConditionTypeRq rq = GetStoreDiscountConditionTypeRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetStoreDiscountConditionTypeRs rs = await _masterService.getStoreDiscountConditionType(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetItemDiscountConditionTypeRs> loadItemDiscountConditionType(AppSession appSession) async {
    const String DATA_KEY = "ITEM_DISCOUNT_COND_TYPE";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetItemDiscountConditionTypeRs localRs;
      try {
        localRs = GetItemDiscountConditionTypeRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetItemDiscountConditionTypeRq rq = GetItemDiscountConditionTypeRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetItemDiscountConditionTypeRs rs = await _masterService.getItemDiscountConditionType(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetCreditCardImageRs> loadCreditCardImage(AppSession appSession) async {
    const String DATA_KEY = "CREDIT_CARD_IMAGE";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetCreditCardImageRs localRs;
      try {
        localRs = GetCreditCardImageRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetCreditCardImageRq rq = GetCreditCardImageRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetCreditCardImageRs rs = await _masterService.getCreditCardImage(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetDeliveryMngRs> loadDeliveryMng(AppSession appSession) async {
    const String DATA_KEY = "DELIVERY_MNG";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetDeliveryMngRs localRs;
      try {
        localRs = GetDeliveryMngRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetDeliveryMngRq rq = GetDeliveryMngRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetDeliveryMngRs rs = await _masterService.getDeliveryMng(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }

  Future<GetMstBankRs> loadMstBank(AppSession appSession) async {
    const String DATA_KEY = "MST_BANK";
    const String SHARED_PREF_KEY = "SHARED_PREF_$DATA_KEY";
    try {
      GetMstBankRs localRs;
      try {
        localRs = GetMstBankRs.fromJson(await SharedPrefUtil.read(SHARED_PREF_KEY));
      } catch (error) {
        print('error load shared pref : $error');
      }

      GetMstBankRq rq = GetMstBankRq();
      rq.lastMasterDataDttm = localRs?.lastMasterDataDttm;
      GetMstBankRs rs = await _masterService.getMstBank(appSession, rq);

      if (MasterDataStatus.LOAD == rs.masterDataStatus) {
        await SharedPrefUtil.save(SHARED_PREF_KEY, rs.toJson());
      } else {
        rs = localRs;
      }
      return rs;
    } catch (error) {
      throw 'LOAD MASTER ERROR > $DATA_KEY : $error';
    }
  }
}
