class GetCustomerMemberRs {
  String custNo;
  String custGrp;
  String title;
  String firstName;
  String lastName;
  String telephone;
  String birthDate;
  String idCard;
  String email;
  List<Cards> cards;
  MessageStatus messageStatus;

  GetCustomerMemberRs(
      {this.custNo,
        this.custGrp,
        this.title,
        this.firstName,
        this.lastName,
        this.telephone,
        this.birthDate,
        this.idCard,
        this.email,
        this.cards,
        this.messageStatus});

  GetCustomerMemberRs.fromJson(Map<String, dynamic> json) {
    custNo = json['CustNo'];
    custGrp = json['CustGrp'];
    title = json['Title'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    telephone = json['Telephone'];
    birthDate = json['BirthDate'];
    idCard = json['IdCard'];
    email = json['Email'];
    if (json['Cards'] != null) {
      cards = new List<Cards>();
      json['Cards'].forEach((v) {
        cards.add(new Cards.fromJson(v));
      });
    }
    messageStatus = json['MessageStatus'] != null
        ? new MessageStatus.fromJson(json['MessageStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustNo'] = this.custNo;
    data['CustGrp'] = this.custGrp;
    data['Title'] = this.title;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Telephone'] = this.telephone;
    data['BirthDate'] = this.birthDate;
    data['IdCard'] = this.idCard;
    data['Email'] = this.email;
    if (this.cards != null) {
      data['Cards'] = this.cards.map((v) => v.toJson()).toList();
    }
    if (this.messageStatus != null) {
      data['MessageStatus'] = this.messageStatus.toJson();
    }
    return data;
  }
}

class Cards {
  String cardNo;
  String cardTypeNo;
  String cardTypeName;
  String startDate;
  String endDate;
  String village;
  String floor;
  String unit;
  String homeNumber;
  String moo;
  String soi;
  String street;
  String subDistrict;
  String district;
  String province;
  String postcode;
  String country;
  String email;
  String gradeNo;
  String campaignNo;
  String placeId;
  String building;
  List<RewardPoints> rewardPoints;
  ServiceData serviceData;
  String cardTier;
  String cardTypeNoTier;

  Cards(
      {this.cardNo,
        this.cardTypeNo,
        this.cardTypeName,
        this.startDate,
        this.endDate,
        this.village,
        this.floor,
        this.unit,
        this.homeNumber,
        this.moo,
        this.soi,
        this.street,
        this.subDistrict,
        this.district,
        this.province,
        this.postcode,
        this.country,
        this.email,
        this.gradeNo,
        this.campaignNo,
        this.placeId,
        this.building,
        this.rewardPoints,
        this.serviceData,
        this.cardTier,
        this.cardTypeNoTier});

  Cards.fromJson(Map<String, dynamic> json) {
    cardNo = json['CardNo'];
    cardTypeNo = json['CardTypeNo'];
    cardTypeName = json['CardTypeName'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    village = json['Village'];
    floor = json['Floor'];
    unit = json['Unit'];
    homeNumber = json['HomeNumber'];
    moo = json['Moo'];
    soi = json['Soi'];
    street = json['Street'];
    subDistrict = json['SubDistrict'];
    district = json['District'];
    province = json['Province'];
    postcode = json['Postcode'];
    country = json['Country'];
    email = json['Email'];
    gradeNo = json['GradeNo'];
    campaignNo = json['CampaignNo'];
    placeId = json['PlaceId'];
    building = json['Building'];
    if (json['RewardPoints'] != null) {
      rewardPoints = new List<RewardPoints>();
      json['RewardPoints'].forEach((v) {
        rewardPoints.add(new RewardPoints.fromJson(v));
      });
    }
    serviceData = json['ServiceData'] != null
        ? new ServiceData.fromJson(json['ServiceData'])
        : null;
    cardTier = json['CardTier'];
    cardTypeNoTier = json['CardTypeNoTier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CardNo'] = this.cardNo;
    data['CardTypeNo'] = this.cardTypeNo;
    data['CardTypeName'] = this.cardTypeName;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Village'] = this.village;
    data['Floor'] = this.floor;
    data['Unit'] = this.unit;
    data['HomeNumber'] = this.homeNumber;
    data['Moo'] = this.moo;
    data['Soi'] = this.soi;
    data['Street'] = this.street;
    data['SubDistrict'] = this.subDistrict;
    data['District'] = this.district;
    data['Province'] = this.province;
    data['Postcode'] = this.postcode;
    data['Country'] = this.country;
    data['Email'] = this.email;
    data['GradeNo'] = this.gradeNo;
    data['CampaignNo'] = this.campaignNo;
    data['PlaceId'] = this.placeId;
    data['Building'] = this.building;
    if (this.rewardPoints != null) {
      data['RewardPoints'] = this.rewardPoints.map((v) => v.toJson()).toList();
    }
    if (this.serviceData != null) {
      data['ServiceData'] = this.serviceData.toJson();
    }
    data['CardTier'] = this.cardTier;
    data['CardTypeNoTier'] = this.cardTypeNoTier;
    return data;
  }
}

class RewardPoints {
  String pointType;
  int point;
  String pointExpire;

  RewardPoints({this.pointType, this.point, this.pointExpire});

  RewardPoints.fromJson(Map<String, dynamic> json) {
    pointType = json['PointType'];
    point = json['Point'];
    pointExpire = json['PointExpire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PointType'] = this.pointType;
    data['Point'] = this.point;
    data['PointExpire'] = this.pointExpire;
    return data;
  }
}

class ServiceData {
  int balance;
  List<Services> services;

  ServiceData({this.balance, this.services});

  ServiceData.fromJson(Map<String, dynamic> json) {
    balance = json['Balance'];
    if (json['Services'] != null) {
      services = new List<Services>();
      json['Services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Balance'] = this.balance;
    if (this.services != null) {
      data['Services'] = this.services.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String couponNo;
  String articleId;
  String articleName;
  String unit;
  int salesPrice;
  String servNo;
  String servNoName;
  String serviceType;
  String productType;
  String transDate;
  String expiryDate;
  int normalPrice;
  int promotionPrice;
  int memberPrice;

  Services(
      {this.couponNo,
        this.articleId,
        this.articleName,
        this.unit,
        this.salesPrice,
        this.servNo,
        this.servNoName,
        this.serviceType,
        this.productType,
        this.transDate,
        this.expiryDate,
        this.normalPrice,
        this.promotionPrice,
        this.memberPrice});

  Services.fromJson(Map<String, dynamic> json) {
    couponNo = json['CouponNo'];
    articleId = json['ArticleId'];
    articleName = json['ArticleName'];
    unit = json['Unit'];
    salesPrice = json['SalesPrice'];
    servNo = json['ServNo'];
    servNoName = json['ServNoName'];
    serviceType = json['ServiceType'];
    productType = json['ProductType'];
    transDate = json['TransDate'];
    expiryDate = json['ExpiryDate'];
    normalPrice = json['NormalPrice'];
    promotionPrice = json['PromotionPrice'];
    memberPrice = json['MemberPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CouponNo'] = this.couponNo;
    data['ArticleId'] = this.articleId;
    data['ArticleName'] = this.articleName;
    data['Unit'] = this.unit;
    data['SalesPrice'] = this.salesPrice;
    data['ServNo'] = this.servNo;
    data['ServNoName'] = this.servNoName;
    data['ServiceType'] = this.serviceType;
    data['ProductType'] = this.productType;
    data['TransDate'] = this.transDate;
    data['ExpiryDate'] = this.expiryDate;
    data['NormalPrice'] = this.normalPrice;
    data['PromotionPrice'] = this.promotionPrice;
    data['MemberPrice'] = this.memberPrice;
    return data;
  }
}

class MessageStatus {
  String status;
  String message;

  MessageStatus({this.status, this.message});

  MessageStatus.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }
}