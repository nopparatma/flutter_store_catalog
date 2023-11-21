import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/common/sms_otp_rq.dart';
import 'package:flutter_store_catalog/core/models/common/sms_otp_rs.dart';
import 'package:flutter_store_catalog/core/models/common/validate_otp_rq.dart';
import 'package:flutter_store_catalog/core/models/common/validate_otp_rs.dart';
import 'package:flutter_store_catalog/core/models/sson/get_config_rq.dart';
import 'package:flutter_store_catalog/core/models/sson/get_config_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/customer_service.dart';
import 'package:flutter_store_catalog/core/services/common/sms_service.dart';
import 'package:flutter_store_catalog/core/services/sson/master_service.dart';
import 'package:meta/meta.dart';
import 'package:easy_localization/easy_localization.dart';

part 'search_customer_event.dart';

part 'search_customer_state.dart';

class SearchCustomerBloc extends Bloc<SearchCustomerEvent, SearchCustomerState> {
  final CustomerService _customerService = getIt<CustomerService>();
  final ApplicationBloc applicationBloc;

  SearchCustomerBloc(this.applicationBloc);

  final SMSService _smsService = getIt<SMSService>();
  final MasterService _masterService = getIt<MasterService>();

  static const String CONFIG_OTP_GROUP = 'OTP';
  static const String OTP_SMS_ID = 'OTP_SMS_ID';
  static const String OTP_TIMEOUT_IN_SEC = 'OTP_TIMEOUT_IN_SEC';

  @override
  SearchCustomerState get initialState => InitialSearchCustomerState();

  @override
  Stream<SearchCustomerState> mapEventToState(SearchCustomerEvent event) async* {
    if (event is ResetSearchCustomerEvent) {
      yield InitialSearchCustomerState();
    } else if (event is SearchCustomerSearchEvent) {
      yield* mapSearchCustomerToState(event);
    } else if (event is SendOtpEvent) {
      yield* mapEvenSendOtpToState(event);
    } else if (event is ValidateOtpEvent) {
      yield* mapEvenValidateOtpToState(event);
    }
  }

  Stream<SearchCustomerState> mapSearchCustomerToState(SearchCustomerSearchEvent event) async* {
    try {
      yield LoadingSearchCustomerByState();

      SearchCustomerRq req = new SearchCustomerRq();
      if (TypeOfCustomerSearch.TELEPHONE == event.searchCondition) {
        req.phoneNo = event.searchValue;
      } else if (TypeOfCustomerSearch.CUSTNO == event.searchCondition) {
        req.sapId = event.searchValue;
      } else if (TypeOfCustomerSearch.MEMBERNO == event.searchCondition) {
        req.cardNo = event.searchValue;
      } else if (TypeOfCustomerSearch.FULLNAME == event.searchCondition) {
        req.fname = event.searchFirstName;
        req.lname = event.searchLastName;
      } else if (TypeOfCustomerSearch.IDCARD == event.searchCondition) {
        req.taxid = event.searchValue;
      }
      req.firstRow = 0;
      req.pageSize = 10;

      if (event.pageSize != null) {
        req.pageSize = event.pageSize;
      }

      if (event.partnerTypeId != null) {
        req.partnerTypeId = event.partnerTypeId;
      }

      AppSession appSession = applicationBloc.state.appSession;
      SearchCustomerRs rs = await _customerService.searchCustomer(appSession, req);

      if (rs == null || rs.customers.isEmpty) {
        yield CustomerNotFoundState(phoneNo :TypeOfCustomerSearch.TELEPHONE == event.searchCondition ? event.searchValue : null);
        return;
      }
      yield SuccessSearchByCustomerByState(rs.customers, searchValue: event.searchValue);
    } catch (error, stackTrace) {
      yield ErrorSearchCustomerByState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<SearchCustomerState> mapEvenSendOtpToState(SendOtpEvent event) async* {
    try {
      yield LoadingOtpState();

      GetConfigRq crq = GetConfigRq();
      crq.data2 = CONFIG_OTP_GROUP;
      GetConfigRs crs = await _masterService.getConfigRq(crq);

      if (crs.configs == null || !crs.configs.any((e) => e.keyname == OTP_SMS_ID) || !crs.configs.any((e) => e.keyname == OTP_TIMEOUT_IN_SEC)) {
        yield ErrorOtpState(AppException('Cannot get OTP config'));
        return;
      }

      String otpSMSId = crs.configs.firstWhere((e) => e.keyname == OTP_SMS_ID).data1;
      int otpTimeoutInSecond = int.parse(crs.configs.firstWhere((e) => e.keyname == OTP_TIMEOUT_IN_SEC).data1);

      SendOTPRq rq = SendOTPRq();
      rq.isNotCheckCust = true;
      rq.sMSPromID = otpSMSId;
      rq.mobileNo = event.telephoneNo;

      SendOTPRs rs = await _smsService.sendOTP(rq);

      yield SuccesSendOtpState(otpSMSId: otpSMSId, otpId: rs.transID, refCode: rs.refCode, timeoutInSecond: otpTimeoutInSecond);
    } catch (error, stackTrace) {
      yield ErrorOtpState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<SearchCustomerState> mapEvenValidateOtpToState(ValidateOtpEvent event) async* {
    try {
      yield LoadingOtpState();

      ValidateOTPRq rq = ValidateOTPRq();
      rq.mobileNo = event.telephoneNo;
      rq.sMSPromID = event.otpSMSId;
      rq.oTPCode = event.otpCode;
      rq.transID = event.otpId;

      ValidateOTPRs rs = await _smsService.validateOTP(rq);

      yield SuccesValidateOtpState();
    } catch (error, stackTrace) {
      if (error is ErrorWebApiException && error.objRs is ValidateOTPRs) {
        ValidateOTPRs rs = error.objRs;
        if (rs.validateStatus == 'E') {
          yield ErrorOtpState(AppException('common.invalid_otp_code'.tr(), errorType: ErrorType.WARNING));
          return;
        }
      }
      yield ErrorOtpState(AppException(error, stackTrace: stackTrace));
    }
  }
}
