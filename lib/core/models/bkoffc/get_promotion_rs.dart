import 'dart:collection';
import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';

class GetPromotionRs extends BaseBackOfficeWebApiRs {
  Promotions promotions;

  GetPromotionRs({this.promotions});

  GetPromotionRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    promotions = json['promotions'] != null ? new Promotions.fromJson(json['promotions']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.promotions != null) {
      data['promotions'] = this.promotions.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Promotions {
  DateTime actualEndTime;
  DateTime actualStartTime;
  Article article;
  String blockCodeCoverage;
  List<BlockCodeCoverages> blockCodeCoverages;
  String blueSpherePromotionType;
  String brandCoverage;
  List<BrandCoverages> brandCoverages;
  String buyConditionType;
  num buyingLimitQuantityPerBill;
  num buyingQuantity;
  String categoryId;
  DateTime createDate;
  DateTime createDateTime;
  String createUserName;
  CreditCard creditCard;
  String creditCardCoverage;
  List<CreditCardCoverages> creditCardCoverages;
  String description;
  String discountConditionTypeCoverage;
  List<DiscountConditionTypeCoverages> discountConditionTypeCoverages;
  DateTime endDate;
  DateTime endTime;
  List<HierarchyConditions> hierarchyConditions;
  HirePurchaseCompany hirePurchaseCompany;
  bool isActive;
  bool isAllDay;
  bool isApplicableOtherCorperatePromotion;
  bool isBlueSpherePromotion;
  bool isCouponQty;
  bool isEveryDay;
  bool isFriday;
  bool isIncludeSapMemberPrice;
  bool isIncludeSapPromotionPrice;
  bool isMonday;
  bool isPrint;
  bool isPromotionGroup;
  bool isPromotionSet;
  bool isSaturday;
  bool isSunday;
  bool isThursday;
  bool isTuesday;
  bool isWednesday;
  DateTime lastPublishedDateTime;
  String mainUPC;
  String memberCardCoverage;
  List<MemberCardCoverages> memberCardCoverages;
  List<MemberCardNotCoverages> memberCardNotCoverages;
  String memberCardTypeCoverage;
  String memberCardTypeNotCoverage;
  List<MemberCoverages> memberCoverages;
  List<MemberNotCoverages> memberNotCoverages;
  num minimumBuyingAmount;
  String name;
  PriceGroup priceGroup;
  List<PromotionArticleTiers> promotionArticleTiers;
  String promotionCoverage;
  List<PromotionCoverages> promotionCoverages;
  List<PromotionGroupArticles> promotionGroupArticles;
  String promotionId;
  List<PromotionSetArticles> promotionSetArticles;
  String promotionTypeId;
  num quantityConditionType;
  String referencePublishId;
  String salesTypeCoverage;
  List<SalesTypeCoverages> salesTypeCoverages;
  String sellUnit;
  DateTime startDate;
  DateTime startTime;
  String storeCoverage;
  List<StoreCoverages> storeCoverages;
  String storeGroupCoverage;
  List<StoreGroupCoverages> storeGroupCoverages;
  Tender tender;
  String tenderCoverage;
  List<TenderCoverages> tenderCoverages;
  String tenderPromotionType;
  String vendorCoverage;
  List<VendorCoverages> vendorCoverages;

  Promotions(
      {this.actualEndTime,
      this.actualStartTime,
      this.article,
      this.blockCodeCoverage,
      this.blockCodeCoverages,
      this.blueSpherePromotionType,
      this.brandCoverage,
      this.brandCoverages,
      this.buyConditionType,
      this.buyingLimitQuantityPerBill,
      this.buyingQuantity,
      this.categoryId,
      this.createDate,
      this.createDateTime,
      this.createUserName,
      this.creditCard,
      this.creditCardCoverage,
      this.creditCardCoverages,
      this.description,
      this.discountConditionTypeCoverage,
      this.discountConditionTypeCoverages,
      this.endDate,
      this.endTime,
      this.hierarchyConditions,
      this.hirePurchaseCompany,
      this.isActive,
      this.isAllDay,
      this.isApplicableOtherCorperatePromotion,
      this.isBlueSpherePromotion,
      this.isCouponQty,
      this.isEveryDay,
      this.isFriday,
      this.isIncludeSapMemberPrice,
      this.isIncludeSapPromotionPrice,
      this.isMonday,
      this.isPrint,
      this.isPromotionGroup,
      this.isPromotionSet,
      this.isSaturday,
      this.isSunday,
      this.isThursday,
      this.isTuesday,
      this.isWednesday,
      this.lastPublishedDateTime,
      this.mainUPC,
      this.memberCardCoverage,
      this.memberCardCoverages,
      this.memberCardNotCoverages,
      this.memberCardTypeCoverage,
      this.memberCardTypeNotCoverage,
      this.memberCoverages,
      this.memberNotCoverages,
      this.minimumBuyingAmount,
      this.name,
      this.priceGroup,
      this.promotionArticleTiers,
      this.promotionCoverage,
      this.promotionCoverages,
      this.promotionGroupArticles,
      this.promotionId,
      this.promotionSetArticles,
      this.promotionTypeId,
      this.quantityConditionType,
      this.referencePublishId,
      this.salesTypeCoverage,
      this.salesTypeCoverages,
      this.sellUnit,
      this.startDate,
      this.startTime,
      this.storeCoverage,
      this.storeCoverages,
      this.storeGroupCoverage,
      this.storeGroupCoverages,
      this.tender,
      this.tenderCoverage,
      this.tenderCoverages,
      this.tenderPromotionType,
      this.vendorCoverage,
      this.vendorCoverages});

  Promotions.fromJson(Map<String, dynamic> json) {
    actualEndTime = DateTimeUtil.toDateTime(json['actualEndTime']);
    actualStartTime = DateTimeUtil.toDateTime(json['actualEndTime']);
    article = json['article'] != null ? new Article.fromJson(json['article']) : null;
    blockCodeCoverage = json['blockCodeCoverage'];
    if (json['blockCodeCoverages'] != null) {
      blockCodeCoverages = new List<BlockCodeCoverages>();
      json['blockCodeCoverages'].forEach((v) {
        blockCodeCoverages.add(new BlockCodeCoverages.fromJson(v));
      });
    }
    blueSpherePromotionType = json['blueSpherePromotionType'];
    brandCoverage = json['brandCoverage'];
    if (json['brandCoverages'] != null) {
      brandCoverages = new List<BrandCoverages>();
      json['brandCoverages'].forEach((v) {
        brandCoverages.add(new BrandCoverages.fromJson(v));
      });
    }
    buyConditionType = json['buyConditionType'];
    buyingLimitQuantityPerBill = json['buyingLimitQuantityPerBill'];
    buyingQuantity = json['buyingQuantity'];
    categoryId = json['categoryId'];
    createDate = DateTimeUtil.toDateTime(json['createDate']);
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    creditCard = json['creditCard'] != null ? new CreditCard.fromJson(json['creditCard']) : null;
    creditCardCoverage = json['creditCardCoverage'];
    if (json['creditCardCoverages'] != null) {
      creditCardCoverages = new List<CreditCardCoverages>();
      json['creditCardCoverages'].forEach((v) {
        creditCardCoverages.add(new CreditCardCoverages.fromJson(v));
      });
    }
    description = json['description'];
    discountConditionTypeCoverage = json['discountConditionTypeCoverage'];
    if (json['discountConditionTypeCoverages'] != null) {
      discountConditionTypeCoverages = new List<DiscountConditionTypeCoverages>();
      json['discountConditionTypeCoverages'].forEach((v) {
        discountConditionTypeCoverages.add(new DiscountConditionTypeCoverages.fromJson(v));
      });
    }
    endDate = DateTimeUtil.toDateTime(json['endDate']);
    endTime = DateTimeUtil.toDateTime(json['endTime']);
    if (json['hierarchyConditions'] != null) {
      hierarchyConditions = new List<HierarchyConditions>();
      json['hierarchyConditions'].forEach((v) {
        hierarchyConditions.add(new HierarchyConditions.fromJson(v));
      });
    }
    hirePurchaseCompany = json['hirePurchaseCompany'] != null ? new HirePurchaseCompany.fromJson(json['hirePurchaseCompany']) : null;
    isActive = json['isActive'];
    isAllDay = json['isAllDay'];
    isApplicableOtherCorperatePromotion = json['isApplicableOtherCorperatePromotion'];
    isBlueSpherePromotion = json['isBlueSpherePromotion'];
    isCouponQty = json['isCouponQty'];
    isEveryDay = json['isEveryDay'];
    isFriday = json['isFriday'];
    isIncludeSapMemberPrice = json['isIncludeSapMemberPrice'];
    isIncludeSapPromotionPrice = json['isIncludeSapPromotionPrice'];
    isMonday = json['isMonday'];
    isPrint = json['isPrint'];
    isPromotionGroup = json['isPromotionGroup'];
    isPromotionSet = json['isPromotionSet'];
    isSaturday = json['isSaturday'];
    isSunday = json['isSunday'];
    isThursday = json['isThursday'];
    isTuesday = json['isTuesday'];
    isWednesday = json['isWednesday'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    mainUPC = json['mainUPC'];
    memberCardCoverage = json['memberCardCoverage'];
    if (json['memberCardCoverages'] != null) {
      memberCardCoverages = new List<MemberCardCoverages>();
      json['memberCardCoverages'].forEach((v) {
        memberCardCoverages.add(new MemberCardCoverages.fromJson(v));
      });
    }
    if (json['memberCardNotCoverages'] != null) {
      memberCardNotCoverages = new List<MemberCardNotCoverages>();
      json['memberCardNotCoverages'].forEach((v) {
        memberCardNotCoverages.add(new MemberCardNotCoverages.fromJson(v));
      });
    }
    memberCardTypeCoverage = json['memberCardTypeCoverage'];
    memberCardTypeNotCoverage = json['memberCardTypeNotCoverage'];
    if (json['memberCoverages'] != null) {
      memberCoverages = new List<MemberCoverages>();
      json['memberCoverages'].forEach((v) {
        memberCoverages.add(new MemberCoverages.fromJson(v));
      });
    }
    if (json['memberNotCoverages'] != null) {
      memberNotCoverages = new List<MemberNotCoverages>();
      json['memberNotCoverages'].forEach((v) {
        memberNotCoverages.add(new MemberNotCoverages.fromJson(v));
      });
    }
    minimumBuyingAmount = json['minimumBuyingAmount'];
    name = json['name'];
    priceGroup = json['priceGroup'] != null ? new PriceGroup.fromJson(json['priceGroup']) : null;
    if (json['promotionArticleTiers'] != null) {
      promotionArticleTiers = new List<PromotionArticleTiers>();
      json['promotionArticleTiers'].forEach((v) {
        promotionArticleTiers.add(new PromotionArticleTiers.fromJson(v));
      });
    }
    promotionCoverage = json['promotionCoverage'];
    if (json['promotionCoverages'] != null) {
      promotionCoverages = new List<PromotionCoverages>();
      json['promotionCoverages'].forEach((v) {
        promotionCoverages.add(new PromotionCoverages.fromJson(v));
      });
    }
    if (json['promotionGroupArticles'] != null) {
      promotionGroupArticles = new List<PromotionGroupArticles>();
      json['promotionGroupArticles'].forEach((v) {
        promotionGroupArticles.add(new PromotionGroupArticles.fromJson(v));
      });
    }
    promotionId = json['promotionId'];
    if (json['promotionSetArticles'] != null) {
      promotionSetArticles = new List<PromotionSetArticles>();
      json['promotionSetArticles'].forEach((v) {
        promotionSetArticles.add(new PromotionSetArticles.fromJson(v));
      });
    }
    promotionTypeId = json['promotionTypeId'];
    quantityConditionType = json['quantityConditionType'];
    referencePublishId = json['referencePublishId'];
    salesTypeCoverage = json['salesTypeCoverage'];
    if (json['salesTypeCoverages'] != null) {
      salesTypeCoverages = new List<SalesTypeCoverages>();
      json['salesTypeCoverages'].forEach((v) {
        salesTypeCoverages.add(new SalesTypeCoverages.fromJson(v));
      });
    }
    sellUnit = json['sellUnit'];
    startDate = DateTimeUtil.toDateTime(json['startDate']);
    startTime = DateTimeUtil.toDateTime(json['startTime']);
    storeCoverage = json['storeCoverage'];
    if (json['storeCoverages'] != null) {
      storeCoverages = new List<StoreCoverages>();
      json['storeCoverages'].forEach((v) {
        storeCoverages.add(new StoreCoverages.fromJson(v));
      });
    }
    storeGroupCoverage = json['storeGroupCoverage'];
    if (json['storeGroupCoverages'] != null) {
      storeGroupCoverages = new List<StoreGroupCoverages>();
      json['storeGroupCoverages'].forEach((v) {
        storeGroupCoverages.add(new StoreGroupCoverages.fromJson(v));
      });
    }
    tender = json['tender'] != null ? new Tender.fromJson(json['tender']) : null;
    tenderCoverage = json['tenderCoverage'];
    if (json['tenderCoverages'] != null) {
      tenderCoverages = new List<TenderCoverages>();
      json['tenderCoverages'].forEach((v) {
        tenderCoverages.add(new TenderCoverages.fromJson(v));
      });
    }
    tenderPromotionType = json['tenderPromotionType'];
    vendorCoverage = json['vendorCoverage'];
    if (json['vendorCoverages'] != null) {
      vendorCoverages = new List<VendorCoverages>();
      json['vendorCoverages'].forEach((v) {
        vendorCoverages.add(new VendorCoverages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actualEndTime'] = this.actualEndTime?.toIso8601String();
    data['actualStartTime'] = this.actualStartTime?.toIso8601String();
    if (this.article != null) {
      data['article'] = this.article.toJson();
    }
    data['blockCodeCoverage'] = this.blockCodeCoverage;
    if (this.blockCodeCoverages != null) {
      data['blockCodeCoverages'] = this.blockCodeCoverages.map((v) => v.toJson()).toList();
    }
    data['blueSpherePromotionType'] = this.blueSpherePromotionType;
    data['brandCoverage'] = this.brandCoverage;
    if (this.brandCoverages != null) {
      data['brandCoverages'] = this.brandCoverages.map((v) => v.toJson()).toList();
    }
    data['buyConditionType'] = this.buyConditionType;
    data['buyingLimitQuantityPerBill'] = this.buyingLimitQuantityPerBill;
    data['buyingQuantity'] = this.buyingQuantity;
    data['categoryId'] = this.categoryId;
    data['createDate'] = this.createDate?.toIso8601String();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    if (this.creditCard != null) {
      data['creditCard'] = this.creditCard.toJson();
    }
    data['creditCardCoverage'] = this.creditCardCoverage;
    if (this.creditCardCoverages != null) {
      data['creditCardCoverages'] = this.creditCardCoverages.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['discountConditionTypeCoverage'] = this.discountConditionTypeCoverage;
    if (this.discountConditionTypeCoverages != null) {
      data['discountConditionTypeCoverages'] = this.discountConditionTypeCoverages.map((v) => v.toJson()).toList();
    }
    data['endDate'] = this.endDate?.toIso8601String();
    data['endTime'] = this.endTime?.toIso8601String();
    if (this.hierarchyConditions != null) {
      data['hierarchyConditions'] = this.hierarchyConditions.map((v) => v.toJson()).toList();
    }
    if (this.hirePurchaseCompany != null) {
      data['hirePurchaseCompany'] = this.hirePurchaseCompany.toJson();
    }
    data['isActive'] = this.isActive;
    data['isAllDay'] = this.isAllDay;
    data['isApplicableOtherCorperatePromotion'] = this.isApplicableOtherCorperatePromotion;
    data['isBlueSpherePromotion'] = this.isBlueSpherePromotion;
    data['isCouponQty'] = this.isCouponQty;
    data['isEveryDay'] = this.isEveryDay;
    data['isFriday'] = this.isFriday;
    data['isIncludeSapMemberPrice'] = this.isIncludeSapMemberPrice;
    data['isIncludeSapPromotionPrice'] = this.isIncludeSapPromotionPrice;
    data['isMonday'] = this.isMonday;
    data['isPrint'] = this.isPrint;
    data['isPromotionGroup'] = this.isPromotionGroup;
    data['isPromotionSet'] = this.isPromotionSet;
    data['isSaturday'] = this.isSaturday;
    data['isSunday'] = this.isSunday;
    data['isThursday'] = this.isThursday;
    data['isTuesday'] = this.isTuesday;
    data['isWednesday'] = this.isWednesday;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['mainUPC'] = this.mainUPC;
    data['memberCardCoverage'] = this.memberCardCoverage;
    if (this.memberCardCoverages != null) {
      data['memberCardCoverages'] = this.memberCardCoverages.map((v) => v.toJson()).toList();
    }
    if (this.memberCardNotCoverages != null) {
      data['memberCardNotCoverages'] = this.memberCardNotCoverages.map((v) => v.toJson()).toList();
    }
    data['memberCardTypeCoverage'] = this.memberCardTypeCoverage;
    data['memberCardTypeNotCoverage'] = this.memberCardTypeNotCoverage;
    if (this.memberCoverages != null) {
      data['memberCoverages'] = this.memberCoverages.map((v) => v.toJson()).toList();
    }
    if (this.memberNotCoverages != null) {
      data['memberNotCoverages'] = this.memberNotCoverages.map((v) => v.toJson()).toList();
    }
    data['minimumBuyingAmount'] = this.minimumBuyingAmount;
    data['name'] = this.name;
    if (this.priceGroup != null) {
      data['priceGroup'] = this.priceGroup.toJson();
    }
    if (this.promotionArticleTiers != null) {
      data['promotionArticleTiers'] = this.promotionArticleTiers.map((v) => v.toJson()).toList();
    }
    data['promotionCoverage'] = this.promotionCoverage;
    if (this.promotionCoverages != null) {
      data['promotionCoverages'] = this.promotionCoverages.map((v) => v.toJson()).toList();
    }
    if (this.promotionGroupArticles != null) {
      data['promotionGroupArticles'] = this.promotionGroupArticles.map((v) => v.toJson()).toList();
    }
    data['promotionId'] = this.promotionId;
    if (this.promotionSetArticles != null) {
      data['promotionSetArticles'] = this.promotionSetArticles.map((v) => v.toJson()).toList();
    }
    data['promotionTypeId'] = this.promotionTypeId;
    data['quantityConditionType'] = this.quantityConditionType;
    data['referencePublishId'] = this.referencePublishId;
    data['salesTypeCoverage'] = this.salesTypeCoverage;
    if (this.salesTypeCoverages != null) {
      data['salesTypeCoverages'] = this.salesTypeCoverages.map((v) => v.toJson()).toList();
    }
    data['sellUnit'] = this.sellUnit;
    data['startDate'] = this.startDate?.toIso8601String();
    data['startTime'] = this.startTime?.toIso8601String();
    data['storeCoverage'] = this.storeCoverage;
    if (this.storeCoverages != null) {
      data['storeCoverages'] = this.storeCoverages.map((v) => v.toJson()).toList();
    }
    data['storeGroupCoverage'] = this.storeGroupCoverage;
    if (this.storeGroupCoverages != null) {
      data['storeGroupCoverages'] = this.storeGroupCoverages.map((v) => v.toJson()).toList();
    }
    if (this.tender != null) {
      data['tender'] = this.tender.toJson();
    }
    data['tenderCoverage'] = this.tenderCoverage;
    if (this.tenderCoverages != null) {
      data['tenderCoverages'] = this.tenderCoverages.map((v) => v.toJson()).toList();
    }
    data['tenderPromotionType'] = this.tenderPromotionType;
    data['vendorCoverage'] = this.vendorCoverage;
    if (this.vendorCoverages != null) {
      data['vendorCoverages'] = this.vendorCoverages.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getPromotionType() {
    if (StringUtil.isNullOrEmpty(this.promotionId)) {
      return '';
    }
    if (this.promotionId.length < 2) {
      return '';
    }
    return this.promotionId.substring(0, 2);
  }

  String getDisplayDate() {
    if (this.startDate == null || this.endDate == null) {
      return '';
    }
    return '${new DateFormat("dd/MM/yyyy").format(this.startDate)} - ${new DateFormat("dd/MM/yyyy").format(this.endDate)}';
  }

  List<StoreGroupStoreCoverageDto> getListStoreGroupStoreCoverageDto() {
    if (this.storeCoverages == null) {
      return null;
    }

    HashMap storeGroupMap = new HashMap<String, List<StoreCoverages>>();

    this.storeCoverages.forEach((element) {
      String key = '${element.storeGroupId},${element.storeGroupName}';

      List<StoreCoverages> groups = storeGroupMap[key];
      if (groups == null) {
        groups = new List<StoreCoverages>();
        storeGroupMap.putIfAbsent(key, () => groups);
      }
      groups.add(element);
    });

    List<StoreGroupStoreCoverageDto> storeGroupStoreCoverages = new List<StoreGroupStoreCoverageDto>();

    storeGroupMap.forEach((key, value) {
      StoreGroupStoreCoverageDto groupDto = new StoreGroupStoreCoverageDto();
      var keyArr = new List(2);

      keyArr = key.split(',');
      groupDto.storeGroupId = keyArr[0];
      groupDto.storeGroupName = keyArr[1];
      groupDto.storeCoverageBos = value;

      storeGroupStoreCoverages.add(groupDto);
    });

    return storeGroupStoreCoverages;
  }

  List<HierarchyConditionDto> getHierarchyConditionDto() {
    if (this.hierarchyConditions == null) {
      return null;
    }

    List<HierarchyConditionDto> result = new List();
    this.hierarchyConditions.forEach((element) {
      HierarchyConditionDto temp = HierarchyConditionDto();
      switch (element.productHierarchy.level) {
        case 1:
          temp.level = 'Main UPC';
          break;
        case 2:
          temp.level = 'Article';
          break;
        case 5:
          temp.level = 'tab_search.mc'.tr();
          break;
        case 6:
          temp.level = 'MCH1';
          break;
        case 7:
          temp.level = 'MCH2';
          break;
        case 8:
          temp.level = 'MCH3';
          break;
        case 9:
          temp.level = 'ALL Item';
          break;
      }
      if (2 == element.productHierarchy.level) {
        temp.id = StringUtil.trimLeftZero(element.productHierarchyId);
      } else if (9 == element.productHierarchy.level) {
        temp.id = '';
      } else {
        temp.id = element.productHierarchyId;
      }

      temp.desc = element.productHierarchyDescription;
      temp.status = element.isInclude ? 'IN' : 'EX';
      result.add(temp);
    });

    return result;
  }
}

class Article {
  String articleId;
  String baseUnit;
  String description;
  bool isLotReq;
  bool isPriceReq;
  bool isQtyReq;
  String itemUpc;
  String mch;
  String name;
  num normalPrice;
  num promotionPrice;
  String rpType;

  Article({this.articleId, this.baseUnit, this.description, this.isLotReq, this.isPriceReq, this.isQtyReq, this.itemUpc, this.mch, this.name, this.normalPrice, this.promotionPrice, this.rpType});

  Article.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    baseUnit = json['baseUnit'];
    description = json['description'];
    isLotReq = json['isLotReq'];
    isPriceReq = json['isPriceReq'];
    isQtyReq = json['isQtyReq'];
    itemUpc = json['itemUpc'];
    mch = json['mch'];
    name = json['name'];
    normalPrice = json['normalPrice'];
    promotionPrice = json['promotionPrice'];
    rpType = json['rpType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['baseUnit'] = this.baseUnit;
    data['description'] = this.description;
    data['isLotReq'] = this.isLotReq;
    data['isPriceReq'] = this.isPriceReq;
    data['isQtyReq'] = this.isQtyReq;
    data['itemUpc'] = this.itemUpc;
    data['mch'] = this.mch;
    data['name'] = this.name;
    data['normalPrice'] = this.normalPrice;
    data['promotionPrice'] = this.promotionPrice;
    data['rpType'] = this.rpType;
    return data;
  }
}

class BlockCodeCoverages {
  String blockCodeId;
  String description;

  BlockCodeCoverages({this.blockCodeId, this.description});

  BlockCodeCoverages.fromJson(Map<String, dynamic> json) {
    blockCodeId = json['blockCodeId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockCodeId'] = this.blockCodeId;
    data['description'] = this.description;
    return data;
  }
}

class BrandCoverages {
  String brandId;
  num promotionOid;

  BrandCoverages({this.brandId, this.promotionOid});

  BrandCoverages.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    promotionOid = json['promotionOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['promotionOid'] = this.promotionOid;
    return data;
  }
}

class CreditCard {
  String creditCardId;
  List<CreditCardOptionLists> creditCardOptionLists;
  String creditCardType;
  String mailId;
  String remark;
  String tenderId;
  String tenderName;
  String tenderNo;

  CreditCard({this.creditCardId, this.creditCardOptionLists, this.creditCardType, this.mailId, this.remark, this.tenderId, this.tenderName, this.tenderNo});

  CreditCard.fromJson(Map<String, dynamic> json) {
    creditCardId = json['creditCardId'];
    if (json['creditCardOptionLists'] != null) {
      creditCardOptionLists = new List<CreditCardOptionLists>();
      json['creditCardOptionLists'].forEach((v) {
        creditCardOptionLists.add(new CreditCardOptionLists.fromJson(v));
      });
    }
    creditCardType = json['creditCardType'];
    mailId = json['mailId'];
    remark = json['remark'];
    tenderId = json['tenderId'];
    tenderName = json['tenderName'];
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditCardId'] = this.creditCardId;
    if (this.creditCardOptionLists != null) {
      data['creditCardOptionLists'] = this.creditCardOptionLists.map((v) => v.toJson()).toList();
    }
    data['creditCardType'] = this.creditCardType;
    data['mailId'] = this.mailId;
    data['remark'] = this.remark;
    data['tenderId'] = this.tenderId;
    data['tenderName'] = this.tenderName;
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}

class CreditCardOptionLists {
  String month;
  String optionId;
  num percentDiscount;

  CreditCardOptionLists({this.month, this.optionId, this.percentDiscount});

  CreditCardOptionLists.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    optionId = json['optionId'];
    percentDiscount = json['percentDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['optionId'] = this.optionId;
    data['percentDiscount'] = this.percentDiscount;
    return data;
  }
}

class CreditCardCoverages {
  String cardLevel;
  num cardRange;
  String cardType;
  String cardVendor;
  String creditCardId;
  String creditCardRangeId;
  String name;

  CreditCardCoverages({this.cardLevel, this.cardRange, this.cardType, this.cardVendor, this.creditCardId, this.creditCardRangeId, this.name});

  CreditCardCoverages.fromJson(Map<String, dynamic> json) {
    cardLevel = json['cardLevel'];
    cardRange = json['cardRange'];
    cardType = json['cardType'];
    cardVendor = json['cardVendor'];
    creditCardId = json['creditCardId'];
    creditCardRangeId = json['creditCardRangeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardLevel'] = this.cardLevel;
    data['cardRange'] = this.cardRange;
    data['cardType'] = this.cardType;
    data['cardVendor'] = this.cardVendor;
    data['creditCardId'] = this.creditCardId;
    data['creditCardRangeId'] = this.creditCardRangeId;
    data['name'] = this.name;
    return data;
  }
}

class DiscountConditionTypeCoverages {
  String discountConditionTypeId;

  DiscountConditionTypeCoverages({this.discountConditionTypeId});

  DiscountConditionTypeCoverages.fromJson(Map<String, dynamic> json) {
    discountConditionTypeId = json['discountConditionTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountConditionTypeId'] = this.discountConditionTypeId;
    return data;
  }
}

class HierarchyConditions {
  bool isInclude;
  ProductHierarchy productHierarchy;
  String productHierarchyDescription;
  String productHierarchyId;

  HierarchyConditions({this.isInclude, this.productHierarchy, this.productHierarchyDescription, this.productHierarchyId});

  HierarchyConditions.fromJson(Map<String, dynamic> json) {
    isInclude = json['isInclude'];
    productHierarchy = json['productHierarchy'] != null ? new ProductHierarchy.fromJson(json['productHierarchy']) : null;
    productHierarchyDescription = json['productHierarchyDescription'];
    productHierarchyId = json['productHierarchyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isInclude'] = this.isInclude;
    if (this.productHierarchy != null) {
      data['productHierarchy'] = this.productHierarchy.toJson();
    }
    data['productHierarchyDescription'] = this.productHierarchyDescription;
    data['productHierarchyId'] = this.productHierarchyId;
    return data;
  }
}

class ProductHierarchy {
  num level;
  String name;

  ProductHierarchy({this.level, this.name});

  ProductHierarchy.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['name'] = this.name;
    return data;
  }
}

class HirePurchaseCompany {
  String createDateTime;
  String createUserName;
  Customer customer;
  String endDate;
  String lastPublishedDateTime;
  String referencePublishId;
  String startDate;

  HirePurchaseCompany({this.createDateTime, this.createUserName, this.customer, this.endDate, this.lastPublishedDateTime, this.referencePublishId, this.startDate});

  HirePurchaseCompany.fromJson(Map<String, dynamic> json) {
    createDateTime = json['createDateTime'];
    createUserName = json['createUserName'];
    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
    endDate = json['endDate'];
    lastPublishedDateTime = json['lastPublishedDateTime'];
    referencePublishId = json['referencePublishId'];
    startDate = json['startDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime;
    data['createUserName'] = this.createUserName;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['endDate'] = this.endDate;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime;
    data['referencePublishId'] = this.referencePublishId;
    data['startDate'] = this.startDate;
    return data;
  }
}


class MemberCardCoverages {
  String cardNo;

  MemberCardCoverages({this.cardNo});

  MemberCardCoverages.fromJson(Map<String, dynamic> json) {
    cardNo = json['cardNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNo'] = this.cardNo;
    return data;
  }
}

class MemberCardNotCoverages {
  String cardNo;

  MemberCardNotCoverages({this.cardNo});

  MemberCardNotCoverages.fromJson(Map<String, dynamic> json) {
    cardNo = json['cardNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNo'] = this.cardNo;
    return data;
  }
}

class MemberCoverages {
  String campaignNo;
  String memberCardTypeId;
  String name;
  String reasonCode;

  MemberCoverages({this.campaignNo, this.memberCardTypeId, this.name, this.reasonCode});

  MemberCoverages.fromJson(Map<String, dynamic> json) {
    campaignNo = json['campaignNo'];
    memberCardTypeId = json['memberCardTypeId'];
    name = json['name'];
    reasonCode = json['reasonCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['campaignNo'] = this.campaignNo;
    data['memberCardTypeId'] = this.memberCardTypeId;
    data['name'] = this.name;
    data['reasonCode'] = this.reasonCode;
    return data;
  }
}

class MemberNotCoverages {
  String memberCardTypeId;
  String name;

  MemberNotCoverages({this.memberCardTypeId, this.name});

  MemberNotCoverages.fromJson(Map<String, dynamic> json) {
    memberCardTypeId = json['memberCardTypeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberCardTypeId'] = this.memberCardTypeId;
    data['name'] = this.name;
    return data;
  }
}

class PriceGroup {
  String lastPublishedDateTime;
  String name;
  String priceGroupId;
  String referencePublishId;

  PriceGroup({this.lastPublishedDateTime, this.name, this.priceGroupId, this.referencePublishId});

  PriceGroup.fromJson(Map<String, dynamic> json) {
    lastPublishedDateTime = json['lastPublishedDateTime'];
    name = json['name'];
    priceGroupId = json['priceGroupId'];
    referencePublishId = json['referencePublishId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastPublishedDateTime'] = this.lastPublishedDateTime;
    data['name'] = this.name;
    data['priceGroupId'] = this.priceGroupId;
    data['referencePublishId'] = this.referencePublishId;
    return data;
  }
}

class PromotionArticleTiers {
  List<PromotionArticleOptions> promotionArticleOptions;
  num tierValue;

  PromotionArticleTiers({this.promotionArticleOptions, this.tierValue});

  PromotionArticleTiers.fromJson(Map<String, dynamic> json) {
    if (json['promotionArticleOptions'] != null) {
      promotionArticleOptions = new List<PromotionArticleOptions>();
      json['promotionArticleOptions'].forEach((v) {
        promotionArticleOptions.add(new PromotionArticleOptions.fromJson(v));
      });
    }
    tierValue = json['tierValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promotionArticleOptions != null) {
      data['promotionArticleOptions'] = this.promotionArticleOptions.map((v) => v.toJson()).toList();
    }
    data['tierValue'] = this.tierValue;
    return data;
  }
}

class PromotionArticleOptions {
  num optionNumber;
  List<PromotionArticleOptionItems> promotionArticleOptionItems;
  String reciveQuantity;
  num reciveValue;
  num remainValue;

  PromotionArticleOptions({this.optionNumber, this.promotionArticleOptionItems, this.reciveQuantity, this.reciveValue, this.remainValue});

  PromotionArticleOptions.fromJson(Map<String, dynamic> json) {
    optionNumber = json['optionNumber'];
    if (json['promotionArticleOptionItems'] != null) {
      promotionArticleOptionItems = new List<PromotionArticleOptionItems>();
      json['promotionArticleOptionItems'].forEach((v) {
        promotionArticleOptionItems.add(new PromotionArticleOptionItems.fromJson(v));
      });
    }
    reciveQuantity = json['reciveQuantity'];
    reciveValue = json['reciveValue'];
    remainValue = json['remainValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionNumber'] = this.optionNumber;
    if (this.promotionArticleOptionItems != null) {
      data['promotionArticleOptionItems'] = this.promotionArticleOptionItems.map((v) => v.toJson()).toList();
    }
    data['reciveQuantity'] = this.reciveQuantity;
    data['reciveValue'] = this.reciveValue;
    data['remainValue'] = this.remainValue;
    return data;
  }
}

class PromotionArticleOptionItems {
  String articleDescription;
  String articleId;
  String discountCode;
  String discountConditionDescription;
  num discountPreMiumPriceValue;
  num discountPriceValue;
  String discountType;
  String effectiveDate;
  String endDate;
  bool isCMKT;
  bool isDiscountConditionDescription;
  bool isLimitMaxValue;
  bool isReceiveFromCS;
  bool isTenderDiscount;
  bool isThisArticle;
  bool isVendorCoupon;
  num limitMaxValue;
  num limitMinValue;
  String promotionArticleId;
  String promotionArticleName;
  PromotionArticleType promotionArticleType;
  num quantity;
  String unit;
  String vendorId;
  String vendorName;

  PromotionArticleOptionItems({this.articleDescription, this.articleId, this.discountCode, this.discountConditionDescription, this.discountPreMiumPriceValue, this.discountPriceValue, this.discountType, this.effectiveDate, this.endDate, this.isCMKT, this.isDiscountConditionDescription, this.isLimitMaxValue, this.isReceiveFromCS, this.isTenderDiscount, this.isThisArticle, this.isVendorCoupon, this.limitMaxValue, this.limitMinValue, this.promotionArticleId, this.promotionArticleName, this.promotionArticleType, this.quantity, this.unit, this.vendorId, this.vendorName});

  PromotionArticleOptionItems.fromJson(Map<String, dynamic> json) {
    articleDescription = json['articleDescription'];
    articleId = json['articleId'];
    discountCode = json['discountCode'];
    discountConditionDescription = json['discountConditionDescription'];
    discountPreMiumPriceValue = json['discountPreMiumPriceValue'];
    discountPriceValue = json['discountPriceValue'];
    discountType = json['discountType'];
    effectiveDate = json['effectiveDate'];
    endDate = json['endDate'];
    isCMKT = json['isCMKT'];
    isDiscountConditionDescription = json['isDiscountConditionDescription'];
    isLimitMaxValue = json['isLimitMaxValue'];
    isReceiveFromCS = json['isReceiveFromCS'];
    isTenderDiscount = json['isTenderDiscount'];
    isThisArticle = json['isThisArticle'];
    isVendorCoupon = json['isVendorCoupon'];
    limitMaxValue = json['limitMaxValue'];
    limitMinValue = json['limitMinValue'];
    promotionArticleId = json['promotionArticleId'];
    promotionArticleName = json['promotionArticleName'];
    promotionArticleType = json['promotionArticleType'] != null ? new PromotionArticleType.fromJson(json['promotionArticleType']) : null;
    quantity = json['quantity'];
    unit = json['unit'];
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDescription'] = this.articleDescription;
    data['articleId'] = this.articleId;
    data['discountCode'] = this.discountCode;
    data['discountConditionDescription'] = this.discountConditionDescription;
    data['discountPreMiumPriceValue'] = this.discountPreMiumPriceValue;
    data['discountPriceValue'] = this.discountPriceValue;
    data['discountType'] = this.discountType;
    data['effectiveDate'] = this.effectiveDate;
    data['endDate'] = this.endDate;
    data['isCMKT'] = this.isCMKT;
    data['isDiscountConditionDescription'] = this.isDiscountConditionDescription;
    data['isLimitMaxValue'] = this.isLimitMaxValue;
    data['isReceiveFromCS'] = this.isReceiveFromCS;
    data['isTenderDiscount'] = this.isTenderDiscount;
    data['isThisArticle'] = this.isThisArticle;
    data['isVendorCoupon'] = this.isVendorCoupon;
    data['limitMaxValue'] = this.limitMaxValue;
    data['limitMinValue'] = this.limitMinValue;
    data['promotionArticleId'] = this.promotionArticleId;
    data['promotionArticleName'] = this.promotionArticleName;
    if (this.promotionArticleType != null) {
      data['promotionArticleType'] = this.promotionArticleType.toJson();
    }
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    return data;
  }
}

class PromotionArticleType {
  bool articlePromotion;
  bool categoryPromotion;
  bool corperatePromotion;
  String lastPublishedDateTime;
  String lastUpdateDate;
  String name;
  bool pricingArticle;
  String promotionArticleTypeId;
  String referencePublishId;
  bool stock;
  bool tenderPromotion;

  PromotionArticleType({this.articlePromotion, this.categoryPromotion, this.corperatePromotion, this.lastPublishedDateTime, this.lastUpdateDate, this.name, this.pricingArticle, this.promotionArticleTypeId, this.referencePublishId, this.stock, this.tenderPromotion});

  PromotionArticleType.fromJson(Map<String, dynamic> json) {
    articlePromotion = json['articlePromotion'];
    categoryPromotion = json['categoryPromotion'];
    corperatePromotion = json['corperatePromotion'];
    lastPublishedDateTime = json['lastPublishedDateTime'];
    lastUpdateDate = json['lastUpdateDate'];
    name = json['name'];
    pricingArticle = json['pricingArticle'];
    promotionArticleTypeId = json['promotionArticleTypeId'];
    referencePublishId = json['referencePublishId'];
    stock = json['stock'];
    tenderPromotion = json['tenderPromotion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articlePromotion'] = this.articlePromotion;
    data['categoryPromotion'] = this.categoryPromotion;
    data['corperatePromotion'] = this.corperatePromotion;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime;
    data['lastUpdateDate'] = this.lastUpdateDate;
    data['name'] = this.name;
    data['pricingArticle'] = this.pricingArticle;
    data['promotionArticleTypeId'] = this.promotionArticleTypeId;
    data['referencePublishId'] = this.referencePublishId;
    data['stock'] = this.stock;
    data['tenderPromotion'] = this.tenderPromotion;
    return data;
  }
}

class PromotionCoverages {
  String name;
  String partnerPromotionId;

  PromotionCoverages({this.name, this.partnerPromotionId});

  PromotionCoverages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    partnerPromotionId = json['partnerPromotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['partnerPromotionId'] = this.partnerPromotionId;
    return data;
  }
}

class PromotionGroupArticles {
  Article article;
  String mainUPC;
  String unit;

  PromotionGroupArticles({this.article, this.mainUPC, this.unit});

  PromotionGroupArticles.fromJson(Map<String, dynamic> json) {
    article = json['article'] != null ? new Article.fromJson(json['article']) : null;
    mainUPC = json['mainUPC'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.article != null) {
      data['article'] = this.article.toJson();
    }
    data['mainUPC'] = this.mainUPC;
    data['unit'] = this.unit;
    return data;
  }
}

class PromotionSetArticles {
  Article article;
  String mainUPC;
  num quantityInSet;
  String unit;

  PromotionSetArticles({this.article, this.mainUPC, this.quantityInSet, this.unit});

  PromotionSetArticles.fromJson(Map<String, dynamic> json) {
    article = json['article'] != null ? new Article.fromJson(json['article']) : null;
    mainUPC = json['mainUPC'];
    quantityInSet = json['quantityInSet'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.article != null) {
      data['article'] = this.article.toJson();
    }
    data['mainUPC'] = this.mainUPC;
    data['quantityInSet'] = this.quantityInSet;
    data['unit'] = this.unit;
    return data;
  }
}

class SalesTypeCoverages {
  String salesTypeId;

  SalesTypeCoverages({this.salesTypeId});

  SalesTypeCoverages.fromJson(Map<String, dynamic> json) {
    salesTypeId = json['salesTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesTypeId'] = this.salesTypeId;
    return data;
  }
}

class StoreCoverages {
  String storeGroupId;
  String storeGroupName;
  String storeId;
  String storeName;

  StoreCoverages({this.storeGroupId, this.storeGroupName, this.storeId, this.storeName});

  StoreCoverages.fromJson(Map<String, dynamic> json) {
    storeGroupId = json['storeGroupId'];
    storeGroupName = json['storeGroupName'];
    storeId = json['storeId'];
    storeName = json['storeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeGroupId'] = this.storeGroupId;
    data['storeGroupName'] = this.storeGroupName;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    return data;
  }
}

class StoreGroupCoverages {
  String storeGroupId;
  String storeGroupName;

  StoreGroupCoverages({this.storeGroupId, this.storeGroupName});

  StoreGroupCoverages.fromJson(Map<String, dynamic> json) {
    storeGroupId = json['storeGroupId'];
    storeGroupName = json['storeGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeGroupId'] = this.storeGroupId;
    data['storeGroupName'] = this.storeGroupName;
    return data;
  }
}

class Tender {
  List<TenderDetails> tenderDetails;
  String tenderNo;

  Tender({this.tenderDetails, this.tenderNo});

  Tender.fromJson(Map<String, dynamic> json) {
    if (json['tenderDetails'] != null) {
      tenderDetails = new List<TenderDetails>();
      json['tenderDetails'].forEach((v) {
        tenderDetails.add(new TenderDetails.fromJson(v));
      });
    }
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tenderDetails != null) {
      data['tenderDetails'] = this.tenderDetails.map((v) => v.toJson()).toList();
    }
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}

class TenderDetails {
  String month;
  String perDisc;
  String periodEnd;
  String periodStart;
  String tenderName;
  String tenderRemark;

  TenderDetails({this.month, this.perDisc, this.periodEnd, this.periodStart, this.tenderName, this.tenderRemark});

  TenderDetails.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    perDisc = json['perDisc'];
    periodEnd = json['periodEnd'];
    periodStart = json['periodStart'];
    tenderName = json['tenderName'];
    tenderRemark = json['tenderRemark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['perDisc'] = this.perDisc;
    data['periodEnd'] = this.periodEnd;
    data['periodStart'] = this.periodStart;
    data['tenderName'] = this.tenderName;
    data['tenderRemark'] = this.tenderRemark;
    return data;
  }
}

class TenderCoverages {
  String name;
  String tenderId;
  String tenderNo;

  TenderCoverages({this.name, this.tenderId, this.tenderNo});

  TenderCoverages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tenderId = json['tenderId'];
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['tenderId'] = this.tenderId;
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}

class VendorCoverages {
  num promotionOid;
  String vendorId;
  String vendorName;

  VendorCoverages({this.promotionOid, this.vendorId, this.vendorName});

  VendorCoverages.fromJson(Map<String, dynamic> json) {
    promotionOid = json['promotionOid'];
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionOid'] = this.promotionOid;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    return data;
  }
}

class StoreGroupStoreCoverageDto {
  String _storeGroupId;
  String _storeGroupName;
  List<StoreCoverages> _storeCoverageBos;

  String get storeGroupId => _storeGroupId;

  set storeGroupId(String value) {
    _storeGroupId = value;
  }

  String get storeGroupName => _storeGroupName;

  set storeGroupName(String value) {
    _storeGroupName = value;
  }

  List<StoreCoverages> get storeCoverageBos => _storeCoverageBos;

  set storeCoverageBos(List<StoreCoverages> value) {
    _storeCoverageBos = value;
  }
}

class HierarchyConditionDto {
  String _level;
  String _id;
  String _desc;
  String _status;

  String get level => _level;

  set level(String value) {
    _level = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }
}

class PromotionArticleDto {
  String _articleId;
  String _articleDesc;
  String _qty;
  String _articleUnit;

  String get articleId => _articleId;

  set articleId(String value) {
    _articleId = value;
  }

  String get articleDesc => _articleDesc;

  set articleDesc(String value) {
    _articleDesc = value;
  }

  String get qty => _qty;

  set qty(String value) {
    _qty = value;
  }

  String get articleUnit => _articleUnit;

  set articleUnit(String value) {
    _articleUnit = value;
  }
}
