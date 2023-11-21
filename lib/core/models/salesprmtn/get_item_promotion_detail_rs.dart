import 'package:flutter_store_catalog/core/constant/constant.dart';

import 'base_sales_promotion_webapi_rs.dart';

class GetItemPromotionDetailRs extends BaseSalesPromotionWebApiRs {
  num discountAmt;
  bool hasFreeGift;
  List<ItemPromotionDiscount> itemPromotionDiscounts;
  List<ItemPromotionFreeGift> itemPromotionFreeGifts;
  num normalPrice;
  num promotionPrice;

  GetItemPromotionDetailRs({
    this.discountAmt,
    this.hasFreeGift,
    this.itemPromotionDiscounts,
    this.itemPromotionFreeGifts,
    this.normalPrice,
    this.promotionPrice,
  });

  GetItemPromotionDetailRs.fromJson(Map<String, dynamic> json) {
    discountAmt = json['discountAmt'];
    hasFreeGift = json['hasFreeGift'];
    if (json['itemPromotionDiscounts'] != null) {
      itemPromotionDiscounts = new List<ItemPromotionDiscount>();
      json['itemPromotionDiscounts'].forEach((v) {
        itemPromotionDiscounts.add(new ItemPromotionDiscount.fromJson(v));
      });
    }
    if (json['itemPromotionFreeGifts'] != null) {
      itemPromotionFreeGifts = new List<ItemPromotionFreeGift>();
      json['itemPromotionFreeGifts'].forEach((v) {
        itemPromotionFreeGifts.add(new ItemPromotionFreeGift.fromJson(v));
      });
    }
    normalPrice = json['normalPrice'];
    promotionPrice = json['promotionPrice'];
    rsMsgCode = json['rsMsgCode'];
    rsMsgDesc = json['rsMsgDesc'];
    rsStatus = json['rsStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountAmt'] = this.discountAmt;
    data['hasFreeGift'] = this.hasFreeGift;
    if (this.itemPromotionDiscounts != null) {
      data['itemPromotionDiscounts'] = this.itemPromotionDiscounts.map((v) => v.toJson()).toList();
    }
    if (this.itemPromotionFreeGifts != null) {
      data['itemPromotionFreeGifts'] = this.itemPromotionFreeGifts.map((v) => v.toJson()).toList();
    }
    data['normalPrice'] = this.normalPrice;
    data['promotionPrice'] = this.promotionPrice;
    data['rsMsgCode'] = this.rsMsgCode;
    data['rsMsgDesc'] = this.rsMsgDesc;
    data['rsStatus'] = this.rsStatus;
    return data;
  }
}

class ItemPromotionDiscount {
  num discountAmt;
  bool isTenderDiscount;
  String promotionId;

  ItemPromotionDiscount({this.discountAmt, this.isTenderDiscount, this.promotionId});

  ItemPromotionDiscount.fromJson(Map<String, dynamic> json) {
    discountAmt = json['discountAmt'];
    isTenderDiscount = json['isTenderDiscount'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountAmt'] = this.discountAmt;
    data['isTenderDiscount'] = this.isTenderDiscount;
    data['promotionId'] = this.promotionId;
    return data;
  }
}

class ItemPromotionFreeGift {
  num discountPriceValue;
  String promotionArtcDesc;
  String promotionArtcId;
  String promotionArtcTypeId;
  String promotionId;
  num qty;
  String unit;

  String getItemImage() {
    if (PromotionArticleTypeId.GIFT == promotionArtcTypeId) return 'assets/images/free_gift.png';
    if (PromotionArticleTypeId.SERVICE_1 == promotionArtcTypeId) return 'assets/images/free_service.png';
    if (PromotionArticleTypeId.SERVICE_2 == promotionArtcTypeId) return 'assets/images/free_service.png';
    return 'assets/images/non_article_image.png';
  }

  ItemPromotionFreeGift({this.discountPriceValue, this.promotionArtcDesc, this.promotionArtcId, this.promotionArtcTypeId, this.promotionId, this.qty, this.unit});

  ItemPromotionFreeGift.fromJson(Map<String, dynamic> json) {
    discountPriceValue = json['discountPriceValue'];
    promotionArtcDesc = json['promotionArtcDesc'];
    promotionArtcId = json['promotionArtcId'];
    promotionArtcTypeId = json['promotionArtcTypeId'];
    promotionId = json['promotionId'];
    qty = json['qty'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountPriceValue'] = this.discountPriceValue;
    data['promotionArtcDesc'] = this.promotionArtcDesc;
    data['promotionArtcId'] = this.promotionArtcId;
    data['promotionArtcTypeId'] = this.promotionArtcTypeId;
    data['promotionId'] = this.promotionId;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    return data;
  }
}
