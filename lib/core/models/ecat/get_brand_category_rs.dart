import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

import 'get_category_rs.dart';

class GetBrandCategoryRs extends BaseECatRs{
  String brandId;
  List<MCH2List> mCH2List;

  GetBrandCategoryRs({this.brandId, this.mCH2List});

  GetBrandCategoryRs.fromJson(Map<String, dynamic> json) {
    brandId = json['BrandId'];
    if (json['MCH2List'] != null) {
      mCH2List = new List<MCH2List>();
      json['MCH2List'].forEach((v) {
        mCH2List.add(new MCH2List.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandId'] = this.brandId;
    if (this.mCH2List != null) {
      data['MCH2List'] = this.mCH2List.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

// class MCH2List {
//   String mCH2Id;
//   int mCH2Seq;
//   String mCH2NameTH;
//   String mCH2NameEN;
//   String mCH2ImgUrl;
//   List<MCH1List> mCH1List;
//
//   MCH2List(
//       {this.mCH2Id,
//         this.mCH2Seq,
//         this.mCH2NameTH,
//         this.mCH2NameEN,
//         this.mCH2ImgUrl,
//         this.mCH1List});
//
//   MCH2List.fromJson(Map<String, dynamic> json) {
//     mCH2Id = json['MCH2Id'];
//     mCH2Seq = json['MCH2Seq'];
//     mCH2NameTH = json['MCH2NameTH'];
//     mCH2NameEN = json['MCH2NameEN'];
//     mCH2ImgUrl = json['MCH2ImgUrl'];
//     if (json['MCH1List'] != null) {
//       mCH1List = new List<MCH1List>();
//       json['MCH1List'].forEach((v) {
//         mCH1List.add(new MCH1List.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['MCH2Id'] = this.mCH2Id;
//     data['MCH2Seq'] = this.mCH2Seq;
//     data['MCH2NameTH'] = this.mCH2NameTH;
//     data['MCH2NameEN'] = this.mCH2NameEN;
//     data['MCH2ImgUrl'] = this.mCH2ImgUrl;
//     if (this.mCH1List != null) {
//       data['MCH1List'] = this.mCH1List.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class MCH1List {
//   String mCH1Id;
//   String mCH1Seq;
//   String mCH1NameTH;
//   String mCH1NameEN;
//   String mCH1ImgUrl;
//   List<SearchTermList> searchTermList;
//
//   MCH1List(
//       {this.mCH1Id,
//         this.mCH1Seq,
//         this.mCH1NameTH,
//         this.mCH1NameEN,
//         this.mCH1ImgUrl,
//         this.searchTermList});
//
//   MCH1List.fromJson(Map<String, dynamic> json) {
//     mCH1Id = json['MCH1Id'];
//     mCH1Seq = json['MCH1Seq'];
//     mCH1NameTH = json['MCH1NameTH'];
//     mCH1NameEN = json['MCH1NameEN'];
//     mCH1ImgUrl = json['MCH1ImgUrl'];
//     if (json['SearchTermList'] != null) {
//       searchTermList = new List<SearchTermList>();
//       json['SearchTermList'].forEach((v) {
//         searchTermList.add(new SearchTermList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['MCH1Id'] = this.mCH1Id;
//     data['MCH1Seq'] = this.mCH1Seq;
//     data['MCH1NameTH'] = this.mCH1NameTH;
//     data['MCH1NameEN'] = this.mCH1NameEN;
//     data['MCH1ImgUrl'] = this.mCH1ImgUrl;
//     if (this.searchTermList != null) {
//       data['SearchTermList'] =
//           this.searchTermList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SearchTermList {
//   String mCHId;
//
//   SearchTermList({this.mCHId});
//
//   SearchTermList.fromJson(Map<String, dynamic> json) {
//     mCHId = json['MCHId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['MCHId'] = this.mCHId;
//     return data;
//   }
// }
