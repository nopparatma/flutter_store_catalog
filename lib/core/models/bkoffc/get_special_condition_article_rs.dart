class GetSpecialConditionArticleRs {
  String message;
  List<SpecialConditionItemBos> specialConditionItemBos;
  String status;

  GetSpecialConditionArticleRs({
    this.message,
    this.specialConditionItemBos,
    this.status,
  });

  GetSpecialConditionArticleRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['specialConditionItemBos'] != null) {
      specialConditionItemBos = <SpecialConditionItemBos>[];
      json['specialConditionItemBos'].forEach((v) {
        specialConditionItemBos.add(new SpecialConditionItemBos.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.specialConditionItemBos != null) {
      data['specialConditionItemBos'] = this.specialConditionItemBos.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class SpecialConditionItemBos {
  String articleId;
  bool isAutoCheckSpecialOrder;
  bool isDisableSpecialDts;
  bool isDisableSpecialOrder;
  bool isSpecialDts;
  bool isSpecialOrder;
  String shippingPointId;

  SpecialConditionItemBos({
    this.articleId,
    this.isAutoCheckSpecialOrder,
    this.isDisableSpecialDts,
    this.isDisableSpecialOrder,
    this.isSpecialDts,
    this.isSpecialOrder,
    this.shippingPointId,
  });

  SpecialConditionItemBos.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    isAutoCheckSpecialOrder = json['isAutoCheckSpecialOrder'];
    isDisableSpecialDts = json['isDisableSpecialDts'];
    isDisableSpecialOrder = json['isDisableSpecialOrder'];
    isSpecialDts = json['isSpecialDts'];
    isSpecialOrder = json['isSpecialOrder'];
    shippingPointId = json['shippingPointId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['isAutoCheckSpecialOrder'] = this.isAutoCheckSpecialOrder;
    data['isDisableSpecialDts'] = this.isDisableSpecialDts;
    data['isDisableSpecialOrder'] = this.isDisableSpecialOrder;
    data['isSpecialDts'] = this.isSpecialDts;
    data['isSpecialOrder'] = this.isSpecialOrder;
    data['shippingPointId'] = this.shippingPointId;
    return data;
  }
}
