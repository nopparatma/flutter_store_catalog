import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class GetUserProfileRs extends BaseECatRs {
  String empId;
  String empNo;
  String empName;
  String empNoFull;
  String storeNo;
  String storeDesc;
  String storeIP;
  List<OtherStoreLists> otherStoreLists;
  String groupNo;
  String groupDesc;
  String pwExpireDate;
  String lastLogin;
  int pwFailure;
  List<MenuLists> menuLists;
  String lang;
  String companyCode;
  String errorCode;
  String transactionDate;

  GetUserProfileRs({
    this.empId,
    this.empNo,
    this.empName,
    this.empNoFull,
    this.storeNo,
    this.storeDesc,
    this.storeIP,
    this.otherStoreLists,
    this.groupNo,
    this.groupDesc,
    this.pwExpireDate,
    this.lastLogin,
    this.pwFailure,
    this.menuLists,
    this.lang,
    this.companyCode,
    this.errorCode,
  });

  GetUserProfileRs.fromJson(Map<String, dynamic> json) {
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
    empId = json['EmpId'];
    empNo = json['EmpNo'];
    empName = json['EmpName'];
    empNoFull = json['EmpNoFull'];
    storeNo = json['StoreNo'];
    storeDesc = json['StoreDesc'];
    storeIP = json['StoreIP'];
    if (json['OtherStoreLists'] != null) {
      otherStoreLists = new List<OtherStoreLists>();
      json['OtherStoreLists'].forEach((v) {
        otherStoreLists.add(new OtherStoreLists.fromJson(v));
      });
    }
    groupNo = json['GroupNo'];
    groupDesc = json['GroupDesc'];
    pwExpireDate = json['PwExpireDate'];
    lastLogin = json['LastLogin'];
    pwFailure = json['PwFailure'];
    if (json['MenuLists'] != null) {
      menuLists = new List<MenuLists>();
      json['MenuLists'].forEach((v) {
        menuLists.add(new MenuLists.fromJson(v));
      });
    }
    lang = json['Lang'];
    companyCode = json['CompanyCode'];
    errorCode = json['ErrorCode'];
    transactionDate = json['TransactionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpId'] = this.empId;
    data['EmpNo'] = this.empNo;
    data['EmpName'] = this.empName;
    data['EmpNoFull'] = this.empNoFull;
    data['StoreNo'] = this.storeNo;
    data['StoreDesc'] = this.storeDesc;
    data['StoreIP'] = this.storeIP;
    if (this.otherStoreLists != null) {
      data['OtherStoreLists'] = this.otherStoreLists.map((v) => v.toJson()).toList();
    }
    data['GroupNo'] = this.groupNo;
    data['GroupDesc'] = this.groupDesc;
    data['PwExpireDate'] = this.pwExpireDate;
    data['LastLogin'] = this.lastLogin;
    data['PwFailure'] = this.pwFailure;
    if (this.menuLists != null) {
      data['MenuLists'] = this.menuLists.map((v) => v.toJson()).toList();
    }
    data['Lang'] = this.lang;
    data['CompanyCode'] = this.companyCode;
    data['ErrorCode'] = this.errorCode;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class OtherStoreLists {
  String storeNo;
  String storeDesc;
  String storeIP;

  OtherStoreLists({this.storeNo, this.storeDesc, this.storeIP});

  OtherStoreLists.fromJson(Map<String, dynamic> json) {
    storeNo = json['StoreNo'];
    storeDesc = json['StoreDesc'];
    storeIP = json['StoreIP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StoreNo'] = this.storeNo;
    data['StoreDesc'] = this.storeDesc;
    data['StoreIP'] = this.storeIP;
    return data;
  }
}

class MenuLists {
  String funcNo;
  String funcName;

  MenuLists({this.funcNo, this.funcName});

  MenuLists.fromJson(Map<String, dynamic> json) {
    funcNo = json['FuncNo'];
    funcName = json['FuncName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FuncNo'] = this.funcNo;
    data['FuncName'] = this.funcName;
    return data;
  }
}

