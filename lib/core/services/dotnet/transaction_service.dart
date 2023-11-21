import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/dotnet/transaction_salescart_checklist_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/transaction_salescart_checklist_rq.dart';
import 'package:flutter_store_catalog/core/services/base_dotnet_webapi_service.dart';

class TransactionService extends BaseDotnetWebApiService {
  var appConfig = AppConfig.instance;
  static const String controllerName = 'api/Transaction';

  Future<TransactionSalesCartChecklistRs> transactionSalesCartChecklist(TransactionSalesCartChecklistRq rq) async {
    return await post(
      '${appConfig.salesGuideApiServerUrl}/$controllerName/TransactionSalesCartChecklist',
      rq.toJson(),
          (data) => TransactionSalesCartChecklistRs.fromJson(data),
    );
  }
}

