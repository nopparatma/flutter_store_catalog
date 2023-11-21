import 'package:flutter_store_catalog/core/models/perm_application.dart';

class UserProfile {
  String empId;
  String empNo;
  String empName;
  String groupNo;
  String groupDesc;
  String companyCode;
  String storeId;
  String storeDesc;
  String storeIP;

  String positionName;
  String telephoneNo;
  List<PermApplication> permApplications;

  UserProfile({
    this.empId,
    this.empNo,
    this.empName,
    this.groupNo,
    this.groupDesc,
    this.companyCode,
    this.storeId,
    this.storeDesc,
    this.storeIP,
    this.positionName,
    this.telephoneNo,
    this.permApplications,
  });

  @override
  String toString() {
    return 'UserProfile{empId: $empId, empNo: $empNo, empName: $empName, groupNo: $groupNo, groupDesc: $groupDesc, companyCode: $companyCode, storeId: $storeId, storeDesc: $storeDesc, storeIP: $storeIP}';
  }

  UserProfile.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    empNo = json['empNo'];
    empName = json['empName'];
    groupNo = json['groupNo'];
    groupDesc = json['groupDesc'];
    companyCode = json['companyCode'];
    storeId = json['storeId'];
    storeDesc = json['storeDesc'];
    storeIP = json['storeIP'];
    positionName = json['positionName'];
    telephoneNo = json['telephoneNo'];
    if (json['permApplications'] != null) {
      permApplications = new List<PermApplication>();
      json['permApplications'].forEach((v) {
        permApplications.add(new PermApplication.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['empNo'] = this.empNo;
    data['empName'] = this.empName;
    data['groupNo'] = this.groupNo;
    data['groupDesc'] = this.groupDesc;
    data['companyCode'] = this.companyCode;
    data['storeId'] = this.storeId;
    data['storeDesc'] = this.storeDesc;
    data['storeIP'] = this.storeIP;
    data['positionName'] = this.positionName;
    data['telephoneNo'] = this.telephoneNo;
    if (this.permApplications != null) {
      data['permApplications'] = this.permApplications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
