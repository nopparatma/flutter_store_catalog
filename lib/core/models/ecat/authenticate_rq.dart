class AuthenticateRq {
  String empNo;
  String password;
  String applno;
  String appFunc;
  String pDAFlag;

  AuthenticateRq({this.empNo, this.password, this.applno, this.appFunc, this.pDAFlag});

  AuthenticateRq.fromJson(Map<String, dynamic> json) {
    empNo = json['EmpNo'];
    password = json['Password'];
    applno = json['Applno'];
    appFunc = json['AppFunc'];
    pDAFlag = json['PDAFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpNo'] = this.empNo;
    data['Password'] = this.password;
    data['Applno'] = this.applno;
    data['AppFunc'] = this.appFunc;
    data['PDAFlag'] = this.pDAFlag;
    return data;
  }
}