class GetCalculatorRq {
  String mch;
  String calculatorId;

  GetCalculatorRq({this.mch, this.calculatorId});

  GetCalculatorRq.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    calculatorId = json['CalculatorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    data['CalculatorId'] = this.calculatorId;
    return data;
  }
}
