import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/common/sms_otp_rq.dart';
import 'package:flutter_store_catalog/core/models/common/sms_otp_rs.dart';
import 'package:flutter_store_catalog/core/models/common/validate_otp_rq.dart';
import 'package:flutter_store_catalog/core/models/common/validate_otp_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';
class SMSService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/SMS';

  Future<SendOTPRs> sendOTP(SendOTPRq rq) async {
    return await postForward(
      '${appConfig.commonApiServerUrl}/$controllerName/SendOTP',
      rq.toJson(),
          (data) => SendOTPRs.fromJson(data),
    );
  }

  Future<ValidateOTPRs> validateOTP(ValidateOTPRq rq) async {
    return await postForward(
      '${appConfig.commonApiServerUrl}/$controllerName/ValidateOTP',
      rq.toJson(),
          (data) => ValidateOTPRs.fromJson(data),
    );
  }
}
