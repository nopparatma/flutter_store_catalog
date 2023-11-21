import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

import 'base_bkoffc_webapi_rs.dart';

class GetTopWorkerRs extends BaseBackOfficeWebApiRs {
  bool isSpecifyWorker;
  DateTime lastMasterDataDttm;
  String masterDataStatus;
  List<TopWorker> topWorkerList;

  GetTopWorkerRs({this.isSpecifyWorker, this.lastMasterDataDttm, this.masterDataStatus, this.topWorkerList});

  GetTopWorkerRs.fromJson(Map<String, dynamic> json) {
    isSpecifyWorker = json['isSpecifyWorker'];
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
    if (json['topWorkerList'] != null) {
      topWorkerList = new List<TopWorker>();
      json['topWorkerList'].forEach((v) {
        topWorkerList.add(new TopWorker.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSpecifyWorker'] = this.isSpecifyWorker;
    data['lastMasterDataDttm'] = this.lastMasterDataDttm.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.topWorkerList != null) {
      data['topWorkerList'] = this.topWorkerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopWorker {
  bool isFavoriteWorker;
  String jobType;
  int seq;
  String subName;
  String subNo;
  String workName;
  String workNo;

  TopWorker({this.isFavoriteWorker, this.jobType, this.seq, this.subName, this.subNo, this.workName, this.workNo});

  TopWorker.fromJson(Map<String, dynamic> json) {
    isFavoriteWorker = json['isFavoriteWorker'];
    jobType = json['jobType'];
    seq = json['seq'];
    subName = json['subName'];
    subNo = json['subNo'];
    workName = json['workName'];
    workNo = json['workNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFavoriteWorker'] = this.isFavoriteWorker;
    data['jobType'] = this.jobType;
    data['seq'] = this.seq;
    data['subName'] = this.subName;
    data['subNo'] = this.subNo;
    data['workName'] = this.workName;
    data['workNo'] = this.workNo;
    return data;
  }
}
