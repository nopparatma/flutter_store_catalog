import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetJobTypeByShippointRs extends BaseBackOfficeWebApiRs {
  List<JobType> jobTypes;

  GetJobTypeByShippointRs({this.jobTypes});

  GetJobTypeByShippointRs.fromJson(Map<String, dynamic> json) {
    if (json['jobTypes'] != null) {
      jobTypes = new List<JobType>();
      json['jobTypes'].forEach((v) {
        jobTypes.add(new JobType.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobTypes != null) {
      data['jobTypes'] = this.jobTypes.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class JobType {
  DateTime createDateTime;
  String description;
  String jobTypeId;
  DateTime lastPublishedDateTime;
  String referencePublishId;
  String status;

  JobType({this.createDateTime, this.description, this.jobTypeId, this.lastPublishedDateTime, this.referencePublishId, this.status});

  JobType.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    description = json['description'];
    jobTypeId = json['jobTypeId'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    referencePublishId = json['referencePublishId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['description'] = this.description;
    data['jobTypeId'] = this.jobTypeId;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['referencePublishId'] = this.referencePublishId;
    data['status'] = this.status;
    return data;
  }
}
