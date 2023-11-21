class GetMainProductTypeByJobTypeRq {
  String jobType;
  String shippoint;

  GetMainProductTypeByJobTypeRq({this.jobType, this.shippoint});

  GetMainProductTypeByJobTypeRq.fromJson(Map<String, dynamic> json) {
    jobType = json['jobType'];
    shippoint = json['shippoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobType'] = this.jobType;
    data['shippoint'] = this.shippoint;
    return data;
  }
}
