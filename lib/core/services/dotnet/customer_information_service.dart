import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_customer_member_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_customer_member_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class ClmService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/CustomerInformation';

  Future<GetCustomerMemberRs> getCustomerMember(GetCustomerMemberRq rq) async {
    return await post(
      '${appConfig.clmApiServerUrl}/$controllerName/GetCustomerMember',
      rq.toJson(),
      (data) => GetCustomerMemberRs.fromJson(data),
    );
  }
}

class CustomerInformationService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/CustomerInformation';

  Future<GetCustomerMemberRs> getCustomerMember(GetCustomerMemberRq rq) async {
    return await post(
      '${appConfig.custApiServerUrl}/$controllerName/GetCustomerMember',
      rq.toJson(),
      (data) => GetCustomerMemberRs.fromJson(data),
    );
  }

  String getTierImage(String sapId) {
    return '${appConfig.custApiServerUrl}/$controllerName/GetTierImage/$sapId';
  }
}
