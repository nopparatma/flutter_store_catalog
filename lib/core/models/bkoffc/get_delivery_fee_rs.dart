import 'base_bkoffc_webapi_rs.dart';

class GetDeliveryFeeRs extends BaseBackOfficeWebApiRs {
  List<ArticleDeliveryFee> articleDeliveryFees;
  num minPurchase;
  String storeID;

  GetDeliveryFeeRs({this.articleDeliveryFees, this.minPurchase, this.storeID});

  GetDeliveryFeeRs.fromJson(Map<String, dynamic> json) {
    if (json['articleDeliveryFees'] != null) {
      articleDeliveryFees = new List<ArticleDeliveryFee>();
      json['articleDeliveryFees'].forEach((v) {
        articleDeliveryFees.add(new ArticleDeliveryFee.fromJson(v));
      });
    }
    message = json['message'];
    minPurchase = json['minPurchase'];
    status = json['status'];
    storeID = json['storeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleDeliveryFees != null) {
      data['articleDeliveryFees'] = this.articleDeliveryFees.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['minPurchase'] = this.minPurchase;
    data['status'] = this.status;
    data['storeID'] = this.storeID;
    return data;
  }
}

class ArticleDeliveryFee {
  String artDesc;
  String artNo;
  bool isLotReq;
  bool isPriceReq;
  bool isQtyReq;
  String itemUpc;
  String mchId;
  String queueStyle;
  String servNo;
  num totalPrice;
  String unit;
  String clmFlag;

  /// เอาไว้เปรียบเทียบค่าขนส่งที่หน้าจอ เท่านั้น (ไม่ใช้ยิง API)
  num originalPrice;

  ArticleDeliveryFee({this.artDesc, this.artNo, this.isLotReq, this.isPriceReq, this.isQtyReq, this.itemUpc, this.mchId, this.queueStyle, this.servNo, this.totalPrice, this.unit, this.clmFlag});

  ArticleDeliveryFee.fromJson(Map<String, dynamic> json) {
    artDesc = json['artDesc'];
    artNo = json['artNo'];
    isLotReq = json['isLotReq'];
    isPriceReq = json['isPriceReq'];
    isQtyReq = json['isQtyReq'];
    itemUpc = json['itemUpc'];
    mchId = json['mchId'];
    queueStyle = json['queueStyle'];
    servNo = json['servNo'];
    totalPrice = json['totalPrice'];
    unit = json['unit'];
    clmFlag = json['clmFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artDesc'] = this.artDesc;
    data['artNo'] = this.artNo;
    data['isLotReq'] = this.isLotReq;
    data['isPriceReq'] = this.isPriceReq;
    data['isQtyReq'] = this.isQtyReq;
    data['itemUpc'] = this.itemUpc;
    data['mchId'] = this.mchId;
    data['queueStyle'] = this.queueStyle;
    data['servNo'] = this.servNo;
    data['totalPrice'] = this.totalPrice;
    data['unit'] = this.unit;
    data['clmFlag'] = this.clmFlag;
    return data;
  }
}
