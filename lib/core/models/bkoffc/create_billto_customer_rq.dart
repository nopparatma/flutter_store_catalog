import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class CreateBillToCustomerRq {
  String companyCode;
  String fromStore;
  String fromUser;
  String screenName;
  String idCard;
  Customer billToCustomerBo;
  int soldToCustomerOid;
  String soldToSapId;
  String systemName;

  CreateBillToCustomerRq({this.companyCode, this.fromStore, this.fromUser, this.screenName, this.idCard, this.billToCustomerBo, this.soldToCustomerOid, this.soldToSapId, this.systemName});

  CreateBillToCustomerRq.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    fromStore = json['fromStore'];
    fromUser = json['fromUser'];
    screenName = json['screenName'];
    idCard = json['idCard'];
    billToCustomerBo = json['billToCustomerBo'] != null ? new Customer.fromJson(json['billToCustomerBo']) : null;
    soldToCustomerOid = json['soldToCustomerOid'];
    soldToSapId = json['soldToSapId'];
    systemName = json['systemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['fromStore'] = this.fromStore;
    data['fromUser'] = this.fromUser;
    data['screenName'] = this.screenName;
    data['idCard'] = this.idCard;
    if (this.billToCustomerBo != null) {
      data['billToCustomerBo'] = this.billToCustomerBo.toJson();
    }
    data['soldToCustomerOid'] = this.soldToCustomerOid;
    data['soldToSapId'] = this.soldToSapId;
    data['systemName'] = this.systemName;
    return data;
  }
}
