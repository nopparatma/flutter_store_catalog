class MemberCard {
  final String paymentOptionId;
  final String id;
  final String name;
  final String image;

  MemberCard(this.paymentOptionId, this.id, this.name, this.image);

  static getPointCard() {
    return <MemberCard>[
      MemberCard('1', '1', 'Home Card', ''),
    ];
  }

  static getDiscountCard() {
    return <MemberCard>[
      MemberCard('2', '1', 'Homepro Visa', ''),
    ];
  }

  @override
  String toString() {
    return 'MemberCard{paymentOptionId: $paymentOptionId, id: $id, name: $name, image: $image}';
  }
}

class DiscountStore {
  final String articleNo;
  final String discountConditionTypeId;
  final String description;

  final bool isPercentDiscount;
  final String discountPercent;
  final String discountAmount;

  DiscountStore({this.articleNo, this.discountConditionTypeId, this.description, this.discountPercent, this.discountAmount, this.isPercentDiscount});

  static getDiscountStoreList() {
    return <DiscountStore>[
      DiscountStore(
        articleNo: '251251',
        discountConditionTypeId: '8001',
        description: 'Header Store 5555555555',
        discountAmount: '-281.38',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '257257',
        discountConditionTypeId: '8001',
        description: 'Header Store 5555555555',
        discountAmount: '-281.38',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '255255',
        discountConditionTypeId: '8001',
        description: 'Header Store 5555555555',
        discountAmount: '-281.38',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '252252',
        discountConditionTypeId: '8001',
        description: 'Header Store 5555555555',
        discountAmount: '-281.38',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '251251',
        discountConditionTypeId: '8001',
        description: 'Header Store 5555555555',
        discountAmount: '-281.38',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '256256',
        discountConditionTypeId: '8001',
        description: 'Header Store 5555555555',
        discountAmount: '-281.38',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '251251',
        discountConditionTypeId: '2121',
        discountAmount: '-870.00',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '257257',
        discountConditionTypeId: '2121',
        discountAmount: '-3.30',
        isPercentDiscount: false,
      ),
      DiscountStore(
        articleNo: '255255',
        discountConditionTypeId: '2121',
        discountAmount: '-2.57',
        isPercentDiscount: false,
      ),
    ];
  }
}

class SimulatePaymentPremiumBo {
  final String promotionId;
  final String promotionName;
  final String articleId;
  final String articleName;
  final num premiumQty;
  final DateTime createDateTime;
  final String createUser;
  final DateTime lastUpdateDate;
  final String unit;
  final num salesCartOid;

  SimulatePaymentPremiumBo({this.promotionId, this.promotionName, this.articleId, this.articleName, this.premiumQty, this.createDateTime, this.createUser, this.lastUpdateDate, this.unit, this.salesCartOid});

  static getSimulatePaymentPremiumBo() => <SimulatePaymentPremiumBo>[
        SimulatePaymentPremiumBo(
          articleId: '251251',
          articleName: 'ค.ทำน้ำอุ่น MEX WAVE145ES WHL/BL 4500W',
          premiumQty: 1,
          unit: 'EA',
        ),
      ];
}

class HirePurchaseBo {
  final String articleNo;
  final String articleDesc;
  final String discountConditionTypeId;
  final num priceDiscount;
  final num percentDiscount;
  final String tenderId;
  final String cardType;
  final String status;
  final String mailId;
  final String optionId;
  final String tenderCode;
  final String mail_desc;
  final String periodStart;
  final String periodEnd;
  final String tenderName;
  final String remark;
  final String promotionId;
  final num monthTerm;
  final String isManualApprove;
  final String manualApproveUserId;
  final String createUserId;
  final String createUserName;
  final DateTime createDateTime;
  final String promotionDesc;
  final String promotionHierachyLevel;
  final num minAmtPerArticle;
  final num minAmtPerTicket;
  final num prodHierOid;
  final bool isVendorAbsorb;
  final String mc;
  final String mch1;
  final String mch2;
  final String mch3;
  final String groupId;
  final num seqNo;
  final String hierarchyType;
  final String hierarchyDescription;

  HirePurchaseBo({this.articleNo, this.articleDesc, this.discountConditionTypeId, this.priceDiscount, this.percentDiscount, this.tenderId, this.cardType, this.status, this.mailId, this.optionId, this.tenderCode, this.mail_desc, this.periodStart, this.periodEnd, this.tenderName, this.remark, this.promotionId, this.monthTerm, this.isManualApprove, this.manualApproveUserId, this.createUserId, this.createUserName, this.createDateTime, this.promotionDesc, this.promotionHierachyLevel, this.minAmtPerArticle, this.minAmtPerTicket, this.prodHierOid, this.isVendorAbsorb, this.mc, this.mch1, this.mch2, this.mch3, this.groupId, this.seqNo, this.hierarchyType, this.hierarchyDescription});

  String getHirepurchaseDesc() {
    String str = '';
    if (this.monthTerm != null && this.monthTerm != 0) {
      str = 'ผ่อน ${this.monthTerm.toString()} เดือน ';
    }
    if (this.percentDiscount != null) {
      str = 'ลด ${this.percentDiscount.toString()}%';
    }
    return str;
  }

  static getMockHirePurchaseBoList() => <HirePurchaseBo>[
        HirePurchaseBo(
          articleNo: '255255',
          articleDesc: 'xxxxxaxaaaaxaxaxaxaxaxaxaaaaa',
          promotionHierachyLevel: 'MCH',
          tenderId: '19-HPCD',
          groupId: 'G001000005',
          hierarchyDescription: 'ผ่อน 5 เดือน ลด 1.00%',
          monthTerm: 4,
        ),
        HirePurchaseBo(
          articleNo: '255255',
          articleDesc: 'xxxxxaxaaaaxaxaxaxaxaxaxaaaaa',
          promotionHierachyLevel: 'MCH',
          tenderId: '19-HPCD',
          groupId: 'G001000005',
          hierarchyDescription: 'ผ่อน 5 เดือน ลด 1.00%',
          monthTerm: 6,
        ),
      ];
}
