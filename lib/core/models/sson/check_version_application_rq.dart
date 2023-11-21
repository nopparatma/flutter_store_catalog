class CheckVersionApplicationRq {
  String applno;
  String funcno;
  String version;

  CheckVersionApplicationRq({this.applno, this.funcno, this.version});

  CheckVersionApplicationRq.fromJson(Map<String, dynamic> json) {
    applno = json['Applno'];
    funcno = json['Funcno'];
    version = json['Version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Applno'] = this.applno;
    data['Funcno'] = this.funcno;
    data['Version'] = this.version;
    return data;
  }
}