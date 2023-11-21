import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';
import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';

class GetRoomCategoryRs extends BaseDotnetWebApiRs {
  List<RoomList> roomList;

  GetRoomCategoryRs({this.roomList});

  GetRoomCategoryRs.fromJson(Map<String, dynamic> json) {
    if (json['RoomList'] != null) {
      roomList = [];
      json['RoomList'].forEach((v) {
        roomList.add(new RoomList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roomList != null) {
      data['RoomList'] = this.roomList.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class RoomList {
  String roomId;
  num roomSeq;
  String roomNameTH;
  String roomNameEN;
  String roomImgUrl;
  List<MCH2List> mch2List;

  RoomList({this.roomId, this.roomSeq, this.roomNameTH, this.roomNameEN, this.mch2List, this.roomImgUrl});

  RoomList.fromJson(Map<String, dynamic> json) {
    roomId = json['RoomId'];
    roomSeq = json['RoomSeq'];
    roomNameTH = json['RoomNameTH'];
    roomNameEN = json['RoomNameEN'];
    roomImgUrl = json['RoomImgUrl'];
    if (json['MCH2List'] != null) {
      mch2List = [];
      json['MCH2List'].forEach((v) {
        mch2List.add(new MCH2List.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RoomId'] = this.roomId;
    data['RoomSeq'] = this.roomSeq;
    data['RoomNameTH'] = this.roomNameTH;
    data['RoomNameEN'] = this.roomNameEN;
    if (this.mch2List != null) {
      data['MCH2List'] = this.mch2List.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class MCH2List {
//   String mch2Id;
//   String mch2Seq;
//   String mch2NameTH;
//   String mch2NameEN;
//   String mch2ImgUrl;
//   List<MCH1List> mch1List;
//
//   MCH2List({
//     this.mch2Id,
//     this.mch2Seq,
//     this.mch2NameTH,
//     this.mch2NameEN,
//     this.mch2ImgUrl,
//     this.mch1List,
//   });
//
//   MCH2List.fromJson(Map<String, dynamic> json) {
//     mch2Id = json['MCH2Id'];
//     mch2Seq = json['MCH2Seq'];
//     mch2NameTH = json['MCH2NameTH'];
//     mch2NameEN = json['MCH2NameEN'];
//     mch2ImgUrl = json['MCH2ImgUrl'];
//     if (json['MCH1List'] != null) {
//       mch1List = [];
//       json['MCH1List'].forEach((v) {
//         mch1List.add(new MCH1List.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['MCH2Id'] = this.mch2Id;
//     data['MCH2Seq'] = this.mch2Seq;
//     data['MCH2NameTH'] = this.mch2NameTH;
//     data['MCH2NameEN'] = this.mch2NameEN;
//     data['MCH2ImgUrl'] = this.mch2ImgUrl;
//     if (this.mch1List != null) {
//       data['MCH1List'] = this.mch1List.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class MCH1List {
//   String mch1Id;
//   String mch1Seq;
//   String mch1NameTH;
//   String mch1NameEN;
//   String mch1ImgUrl;
//   List<SearchTermList> searchTermList;
//
//   MCH1List({
//     this.mch1Id,
//     this.mch1Seq,
//     this.mch1NameTH,
//     this.mch1NameEN,
//     this.mch1ImgUrl,
//     this.searchTermList,
//   });
//
//   MCH1List.fromJson(Map<String, dynamic> json) {
//     mch1Id = json['MCH1Id'];
//     mch1Seq = json['MCH1Seq'];
//     mch1NameTH = json['MCH1NameTH'];
//     mch1NameEN = json['MCH1NameEN'];
//     mch1ImgUrl = json['MCH1ImgUrl'];
//     if (json['SearchTermList'] != null) {
//       searchTermList = [];
//       json['SearchTermList'].forEach((v) {
//         searchTermList.add(new SearchTermList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['MCH1Id'] = this.mch1Id;
//     data['MCH1Seq'] = this.mch1Seq;
//     data['MCH1NameTH'] = this.mch1NameTH;
//     data['MCH1NameEN'] = this.mch1NameEN;
//     data['MCH1ImgUrl'] = this.mch1ImgUrl;
//     if (this.searchTermList != null) {
//       data['SearchTermList'] = this.searchTermList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SearchTermList {
//   String mchId;
//
//   SearchTermList({this.mchId});
//
//   SearchTermList.fromJson(Map<String, dynamic> json) {
//     mchId = json['MCHId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['MCHId'] = this.mchId;
//     return data;
//   }
// }
