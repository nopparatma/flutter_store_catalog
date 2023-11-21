import 'package:flutter_store_catalog/core/models/salesprmtn/base_sales_promotion_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rq.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetHirePurchasePromotionRs extends BaseSalesPromotionWebApiRs {
  List<MailList> mailList;

  GetHirePurchasePromotionRs({this.mailList});

  GetHirePurchasePromotionRs.fromJson(Map<String, dynamic> json) {
    if (json['mailList'] != null) {
      mailList = <MailList>[];
      json['mailList'].forEach((v) {
        mailList.add(new MailList.fromJson(v));
      });
    }
    rsMsgCode = json['rsMsgCode'];
    rsMsgDesc = json['rsMsgDesc'];
    rsStatus = json['rsStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mailList != null) {
      data['mailList'] = this.mailList.map((v) => v.toJson()).toList();
    }
    data['rsMsgCode'] = this.rsMsgCode;
    data['rsMsgDesc'] = this.rsMsgDesc;
    data['rsStatus'] = this.rsStatus;
    return data;
  }
}

class MailList {
  List<GroupList> groupList;
  String mailDescription;
  String mailId;
  DateTime periodEnd;
  DateTime periodStart;

  MailList({this.groupList, this.mailDescription, this.mailId, this.periodEnd, this.periodStart});

  MailList.fromJson(Map<String, dynamic> json) {
    if (json['groupList'] != null) {
      groupList = new List<GroupList>();
      json['groupList'].forEach((v) {
        groupList.add(new GroupList.fromJson(v));
      });
    }
    mailDescription = json['mailDescription'];
    mailId = json['mailId'];
    periodEnd = DateTimeUtil.toDateTime(json['periodEnd']);
    periodStart = DateTimeUtil.toDateTime(json['periodStart']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groupList != null) {
      data['groupList'] = this.groupList.map((v) => v.toJson()).toList();
    }
    data['mailDescription'] = this.mailDescription;
    data['mailId'] = this.mailId;
    data['periodEnd'] = this.periodEnd?.toIso8601String();
    data['periodStart'] = this.periodStart?.toIso8601String();
    return data;
  }
}

class GroupList {
  List<ArticleList> articleList;
  String creditCardType;
  String groupId;
  String hierarchyType;
  List<ItemIncludeList> itemIncludeList;
  num minAmtPerTicket;
  List<PromotionList> promotionList;
  String tenderId;
  String tenderName;
  String tenderNo;
  String vendorAbsorb;

  GroupList({this.articleList, this.creditCardType, this.groupId, this.hierarchyType, this.itemIncludeList, this.minAmtPerTicket, this.promotionList, this.tenderId, this.tenderName, this.tenderNo, this.vendorAbsorb});

  GroupList.fromJson(Map<String, dynamic> json) {
    if (json['articleList'] != null) {
      articleList = new List<ArticleList>();
      json['articleList'].forEach((v) {
        articleList.add(new ArticleList.fromJson(v));
      });
    }
    creditCardType = json['creditCardType'];
    groupId = json['groupId'];
    hierarchyType = json['hierarchyType'];
    if (json['itemIncludeList'] != null) {
      itemIncludeList = new List<ItemIncludeList>();
      json['itemIncludeList'].forEach((v) {
        itemIncludeList.add(new ItemIncludeList.fromJson(v));
      });
    }
    minAmtPerTicket = json['minAmtPerTicket'];
    if (json['promotionList'] != null) {
      promotionList = new List<PromotionList>();
      json['promotionList'].forEach((v) {
        promotionList.add(new PromotionList.fromJson(v));
      });
    }
    tenderId = json['tenderId'];
    tenderName = json['tenderName'];
    tenderNo = json['tenderNo'];
    vendorAbsorb = json['vendorAbsorb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleList != null) {
      data['articleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    data['creditCardType'] = this.creditCardType;
    data['groupId'] = this.groupId;
    data['hierarchyType'] = this.hierarchyType;
    if (this.itemIncludeList != null) {
      data['itemIncludeList'] = this.itemIncludeList.map((v) => v.toJson()).toList();
    }
    data['minAmtPerTicket'] = this.minAmtPerTicket;
    if (this.promotionList != null) {
      data['promotionList'] = this.promotionList.map((v) => v.toJson()).toList();
    }
    data['tenderId'] = this.tenderId;
    data['tenderName'] = this.tenderName;
    data['tenderNo'] = this.tenderNo;
    data['vendorAbsorb'] = this.vendorAbsorb;
    return data;
  }
}

class ItemIncludeList {
  String brandId;
  String hierarchyDescription;
  String hierarchyId;
  String hierarchyLevel;
  num minAmtPerArt;

  ItemIncludeList({this.brandId, this.hierarchyDescription, this.hierarchyId, this.hierarchyLevel, this.minAmtPerArt});

  ItemIncludeList.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    hierarchyDescription = json['hierarchyDescription'];
    hierarchyId = json['hierarchyId'];
    hierarchyLevel = json['hierarchyLevel'];
    minAmtPerArt = json['minAmtPerArt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['hierarchyDescription'] = this.hierarchyDescription;
    data['hierarchyId'] = this.hierarchyId;
    data['hierarchyLevel'] = this.hierarchyLevel;
    data['minAmtPerArt'] = this.minAmtPerArt;
    return data;
  }
}

class PromotionList {
  num month;
  String optionId;
  num percentDiscount;
  String promotionId;

  PromotionList({this.month, this.optionId, this.percentDiscount, this.promotionId});

  PromotionList.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    optionId = json['optionId'];
    percentDiscount = json['percentDiscount'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['optionId'] = this.optionId;
    data['percentDiscount'] = this.percentDiscount;
    data['promotionId'] = this.promotionId;
    return data;
  }
}
