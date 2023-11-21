import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class CancelQRq {
  num salesCartOid;
  SalesOrder salesOrderBo;
  String stateQ;
  String updateBy;

  CancelQRq({this.salesCartOid, this.salesOrderBo, this.stateQ, this.updateBy});

  CancelQRq.fromJson(Map<String, dynamic> json) {
    salesCartOid = json['salesCartOid'];
    salesOrderBo = json['salesOrderBo'] != null ? new SalesOrder.fromJson(json['salesOrderBo']) : null;
    stateQ = json['stateQ'];
    updateBy = json['updateBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesCartOid'] = this.salesCartOid;
    if (this.salesOrderBo != null) {
      data['salesOrderBo'] = this.salesOrderBo.toJson();
    }
    data['stateQ'] = this.stateQ;
    data['updateBy'] = this.updateBy;
    return data;
  }
}
