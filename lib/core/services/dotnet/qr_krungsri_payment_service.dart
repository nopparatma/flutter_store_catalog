import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class QRKrungsriPaymentService extends BaseDotnetWebApiService {
  static const String controllerName = 'QRKrungsriPayment';

  var appConfig = AppConfig.instance;

  // Future<QRGeneratorRs> qrGenerator(QRGeneratorRq rq) async {
  //   return await post(
  //     '${appConfig.qrPaymentApiServerUrl}/api/$controllerName/QRGenerator',
  //     rq.toJson(),
  //     (data) => QRGeneratorRs.fromJson(data),
  //   );
  // }
  //
  // Future<QRPaymentInfoRs> qrPaymentInfo(QRPaymentInfoRq rq) async {
  //   return await post(
  //     '${appConfig.qrPaymentApiServerUrl}/api/$controllerName/QRPaymentInfo',
  //     rq.toJson(),
  //         (data) => QRPaymentInfoRs.fromJson(data),
  //   );
  // }
  //
  // Future<UpdateTransactionRs> updateTransaction(UpdateTransactionRq rq) async {
  //   return await post(
  //     '${appConfig.qrPaymentApiServerUrl}/api/$controllerName/UpdateTransaction',
  //     rq.toJson(),
  //     (data) => UpdateTransactionRs.fromJson(data),
  //   );
  // }
}
