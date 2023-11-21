import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class GetCategoryRs extends BaseECatRs {
  List<MCH3List> mCH3List;

  GetCategoryRs({this.mCH3List});

  GetCategoryRs.fromJson(Map<String, dynamic> json) {
    if (json['MCH3List'] != null) {
      mCH3List = new List<MCH3List>();
      json['MCH3List'].forEach((v) {
        mCH3List.add(new MCH3List.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null
        ? new MessageStatusRs.fromJson(json['MessageStatusRs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mCH3List != null) {
      data['MCH3List'] = this.mCH3List.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class MCH3List {
  String mCH3Id;
  String mCH3NameTH;
  String mCH3NameEN;
  String mCH3ImgUrl;
  List<MCH2List> mCH2List;

  MCH3List(
      {this.mCH3Id,
        this.mCH3NameTH,
        this.mCH3NameEN,
        this.mCH3ImgUrl,
        this.mCH2List});

  MCH3List.fromJson(Map<String, dynamic> json) {
    mCH3Id = json['MCH3Id'];
    mCH3NameTH = json['MCH3NameTH'];
    mCH3NameEN = json['MCH3NameEN'];
    mCH3ImgUrl = json['MCH3ImgUrl'];
    if (json['MCH2List'] != null) {
      mCH2List = new List<MCH2List>();
      json['MCH2List'].forEach((v) {
        mCH2List.add(new MCH2List.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH3Id'] = this.mCH3Id;
    data['MCH3NameTH'] = this.mCH3NameTH;
    data['MCH3NameEN'] = this.mCH3NameEN;
    data['MCH3ImgUrl'] = this.mCH3ImgUrl;
    if (this.mCH2List != null) {
      data['MCH2List'] = this.mCH2List.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MCH2List {
  String mCH2Id;
  String mCH2NameTH;
  String mCH2NameEN;
  String mCH2ImgUrl;
  List<MCH1CategoryList> mCH1CategoryList;

  MCH2List(
      {this.mCH2Id,
        this.mCH2NameTH,
        this.mCH2NameEN,
        this.mCH2ImgUrl,
        this.mCH1CategoryList});

  MCH2List.fromJson(Map<String, dynamic> json) {
    mCH2Id = json['MCH2Id'];
    mCH2NameTH = json['MCH2NameTH'];
    mCH2NameEN = json['MCH2NameEN'];
    mCH2ImgUrl = json['MCH2ImgUrl'];
    if (json['MCH1List'] != null) {
      mCH1CategoryList = new List<MCH1CategoryList>();
      json['MCH1List'].forEach((v) {
        mCH1CategoryList.add(new MCH1CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH2Id'] = this.mCH2Id;
    data['MCH2NameTH'] = this.mCH2NameTH;
    data['MCH2NameEN'] = this.mCH2NameEN;
    data['MCH2ImgUrl'] = this.mCH2ImgUrl;
    if (this.mCH1CategoryList != null) {
      data['MCH1List'] =
          this.mCH1CategoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MCH1CategoryList {
  String mCH1Id;
  String mCH1NameTH;
  String mCH1NameEN;
  String mCH1ImgUrl;
  List<SearchTermList> searchTermList;

  MCH1CategoryList(
      {this.mCH1Id, this.mCH1NameTH, this.mCH1NameEN, this.mCH1ImgUrl, this.searchTermList});

  MCH1CategoryList.fromJson(Map<String, dynamic> json) {
    mCH1Id = json['MCH1Id'];
    mCH1NameTH = json['MCH1NameTH'];
    mCH1NameEN = json['MCH1NameEN'];
    mCH1ImgUrl = json['MCH1ImgUrl'];
    if (json['SearchTermList'] != null) {
      searchTermList = new List<SearchTermList>();
      json['SearchTermList'].forEach((v) {
        searchTermList.add(new SearchTermList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH1Id'] = this.mCH1Id;
    data['MCH1NameTH'] = this.mCH1NameTH;
    data['MCH1NameEN'] = this.mCH1NameEN;
    data['MCH1ImgUrl'] = this.mCH1ImgUrl;
    if (this.searchTermList != null) {
      data['SearchTermList'] =
          this.searchTermList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchTermList {
  String mCHId;

  SearchTermList(this.mCHId);

  SearchTermList.fromJson(Map<String, dynamic> json) {
    mCHId = json['MCHId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCHId'] = this.mCHId;
    return data;
  }
}

