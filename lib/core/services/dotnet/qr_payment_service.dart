import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/inquiry_transaction_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/inquiry_transaction_rs.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class QRPaymentService extends BaseDotnetWebApiService {
  static const String controllerName = 'QRPayment';

  var appConfig = AppConfig.instance;

  // Future<CreateTransactionRs> createTransaction(CreateTransactionRq rq) async {
  //   return await post(
  //     '${appConfig.qrPaymentApiServerUrl}/api/$controllerName/CreateTransaction',
  //     rq.toJson(),
  //         (data) => CreateTransactionRs.fromJson(data),
  //   );
  // }

  Future<InquiryTransactionRs> inquiryTransaction(InquiryTransactionRq rq) async {
    return await post(
      '${appConfig.qrPaymentApiServerUrl}/api/$controllerName/InquiryTransaction',
      rq.toJson(),
          (data) => InquiryTransactionRs.fromJson(data),
    );
  }
}