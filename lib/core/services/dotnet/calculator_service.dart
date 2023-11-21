import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_calculator_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_calculator_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class CalculatorService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Calculator';

  Future<GetCalculatorRs> getCalculator(GetCalculatorRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/GetCalculator',
      rq.toJson(),
      (data) => GetCalculatorRs.fromJson(data),
    );
  }

  Future<CalculatorRs> calculator(CalculatorRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/Calculator',
      rq.toJson(),
      (data) => CalculatorRs.fromJson(data),
    );
  }
}
