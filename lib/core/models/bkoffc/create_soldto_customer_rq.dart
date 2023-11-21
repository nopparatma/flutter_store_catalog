
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class CreateSoldToCustomerRq {
  String companyCode;
  String fromStore;
  String fromUser;
  String screenName;
  String idCard;
  Customer soldToCustomerBo;
  String systemName;

  CreateSoldToCustomerRq({this.companyCode, this.fromStore, this.fromUser, this.screenName, this.idCard, this.soldToCustomerBo, this.systemName});

  CreateSoldToCustomerRq.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    fromStore = json['fromStore'];
    fromUser = json['fromUser'];
    screenName = json['screenName'];
    idCard = json['idCard'];
    soldToCustomerBo = json['soldToCustomerBo'] != null ? new Customer.fromJson(json['soldToCustomerBo']) : null;
    systemName = json['systemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['fromStore'] = this.fromStore;
    data['fromUser'] = this.fromUser;
    data['screenName'] = this.screenName;
    data['idCard'] = this.idCard;
    if (this.soldToCustomerBo != null) {
      data['soldToCustomerBo'] = this.soldToCustomerBo.toJson();
    }
    data['systemName'] = this.systemName;
    return data;
  }
}
