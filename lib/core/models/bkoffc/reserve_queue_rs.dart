import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/queue_sale.dart';

class ReserveQueueRs extends BaseBackOfficeWebApiRs {
  List<QueueSale> queueSales;

  ReserveQueueRs({this.queueSales});

  ReserveQueueRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['queueSalesBos'] != null) {
      queueSales = <QueueSale>[];
      json['queueSalesBos'].forEach((v) {
        queueSales.add(new QueueSale.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.queueSales != null) {
      data['queueSalesBos'] = this.queueSales.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}
