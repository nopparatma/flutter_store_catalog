class GetPromotionRq {
  String promotionId;

  GetPromotionRq({this.promotionId});

  GetPromotionRq.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionId'] = this.promotionId;
    return data;
  }
}