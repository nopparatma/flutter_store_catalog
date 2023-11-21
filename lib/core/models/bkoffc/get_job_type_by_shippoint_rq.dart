class GetJobTypeByShippointRq {
  String shippoint;

  GetJobTypeByShippointRq({this.shippoint});

  GetJobTypeByShippointRq.fromJson(Map<String, dynamic> json) {
    shippoint = json['shippoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shippoint'] = this.shippoint;
    return data;
  }
}