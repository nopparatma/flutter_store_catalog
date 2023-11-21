class SpecialConditionItem {
  String articleId;
  bool isAutoCheckSpecialOrder;
  bool isDisableSpecialDts;
  bool isDisableSpecialOrder;
  bool isSpecialDts;
  bool isSpecialOrder;
  String shippingPointId;

  SpecialConditionItem(
      {this.articleId,
        this.isAutoCheckSpecialOrder,
        this.isDisableSpecialDts,
        this.isDisableSpecialOrder,
        this.isSpecialDts,
        this.isSpecialOrder,
        this.shippingPointId});

  SpecialConditionItem.fromJson(Map<String, dynamic> json) {
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