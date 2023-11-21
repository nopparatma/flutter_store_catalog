import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class GetGisDataSourceRs extends BaseBackOfficeWebApiRs {
  List<GeoList> geoList;

  GetGisDataSourceRs({this.geoList});

  GetGisDataSourceRs.fromJson(Map<String, dynamic> json) {
    if (json['geoList'] != null) {
      geoList = new List<GeoList>();
      json['geoList'].forEach((v) {
        geoList.add(new GeoList.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoList != null) {
      data['geoList'] = this.geoList.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class GeoList {
  String geoID;
  String geoNameTH;
  String geoNameEN;
  String geoMoo;
  String geoSoi;
  String geoStreet;
  String geoSubdist;
  String geoDist;
  String geoProv;
  String geoZipcode;
  String geoLon;
  String geoLat;
  String geoMaploc;
  String geoMapno;
  String geoTypeCode;
  String geoTel;
  List<GeoRuleList> geoRuleList;
  List<GeoSynonymList> geoSynonymList;

  GeoList({this.geoID, this.geoNameTH, this.geoNameEN, this.geoMoo, this.geoSoi, this.geoStreet, this.geoSubdist, this.geoDist, this.geoProv, this.geoZipcode, this.geoLon, this.geoLat, this.geoMaploc, this.geoMapno, this.geoTypeCode, this.geoTel, this.geoRuleList, this.geoSynonymList});

  GeoList.fromJson(Map<String, dynamic> json) {
    geoID = json['geoID'];
    geoNameTH = json['geoNameTh'];
    geoNameEN = json['geoNameEn'];
    geoMoo = json['geoMoo'];
    geoSoi = json['geoSoi'];
    geoStreet = json['geoStreet'];
    geoSubdist = json['geoSubdist'];
    geoDist = json['geoDist'];
    geoProv = json['geoProv'];
    geoZipcode = json['geoZipcode'];
    geoLon = json['geoLon'];
    geoLat = json['geoLat'];
    geoMaploc = json['geoMaploc'];
    geoMapno = json['geoMapno'];
    geoTypeCode = json['geoType_Code'];
    geoTel = json['geoTel'];
    if (json['geoRuleList'] != null) {
      geoRuleList = new List<GeoRuleList>();
      json['geoRuleList'].forEach((v) {
        geoRuleList.add(new GeoRuleList.fromJson(v));
      });
    }
    if (json['geoSynonymList'] != null) {
      geoSynonymList = new List<GeoSynonymList>();
      json['geoSynonymList'].forEach((v) {
        geoSynonymList.add(new GeoSynonymList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geoID'] = this.geoID;
    data['geoNameTh'] = this.geoNameTH;
    data['geoNameEn'] = this.geoNameEN;
    data['geoMoo'] = this.geoMoo;
    data['geoSoi'] = this.geoSoi;
    data['geoStreet'] = this.geoStreet;
    data['geoSubdist'] = this.geoSubdist;
    data['geoDist'] = this.geoDist;
    data['geoProv'] = this.geoProv;
    data['geoZipcode'] = this.geoZipcode;
    data['geoLon'] = this.geoLon;
    data['geoLat'] = this.geoLat;
    data['geoMaploc'] = this.geoMaploc;
    data['geoMapno'] = this.geoMapno;
    data['geoType_Code'] = this.geoTypeCode;
    data['geoTel'] = this.geoTel;
    if (this.geoRuleList != null) {
      data['geoRuleList'] = this.geoRuleList.map((v) => v.toJson()).toList();
    }
    if (this.geoSynonymList != null) {
      data['geoSynonymList'] = this.geoSynonymList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeoRuleList {
  String dayKey;
  String dayDescrTH;
  String dayDescrEN;
  String timeStart;
  String timeEnd;

  GeoRuleList({this.dayKey, this.dayDescrTH, this.dayDescrEN, this.timeStart, this.timeEnd});

  GeoRuleList.fromJson(Map<String, dynamic> json) {
    dayKey = json['dayKey'];
    dayDescrTH = json['dayDescrTh'];
    dayDescrEN = json['dayDescrEn'];
    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayKey'] = this.dayKey;
    data['dayDescrTh'] = this.dayDescrTH;
    data['dayDescrEn'] = this.dayDescrEN;
    data['timeStart'] = this.timeStart;
    data['timeEnd'] = this.timeEnd;
    return data;
  }
}

class GeoSynonymList {
  String geoSynonym;

  GeoSynonymList({this.geoSynonym});

  GeoSynonymList.fromJson(Map<String, dynamic> json) {
    geoSynonym = json['geoSynonym'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geoSynonym'] = this.geoSynonym;
    return data;
  }
}
