import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class GetMasterVillageCondoRs extends BaseBackOfficeWebApiRs {
  List<GetMasterVillageCondoGeoList> geoList;
  num rowCount;

  GetMasterVillageCondoRs(
      {this.geoList,
        this.rowCount});

  GetMasterVillageCondoRs.fromJson(Map<String, dynamic> json) {
    if (json['geoList'] != null) {
      geoList = new List<GetMasterVillageCondoGeoList>();
      json['geoList'].forEach((v) {
        geoList.add(new GetMasterVillageCondoGeoList.fromJson(v));
      });
    }
    rowCount = json['rowCount'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoList != null) {
      data['geoList'] = this.geoList.map((v) => v.toJson()).toList();
    }
    data['rowCount'] = this.rowCount;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class GetMasterVillageCondoGeoList {
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

  GetMasterVillageCondoGeoList({this.geoID, this.geoNameTH, this.geoNameEN, this.geoMoo, this.geoSoi, this.geoStreet, this.geoSubdist, this.geoDist, this.geoProv, this.geoZipcode, this.geoLon, this.geoLat, this.geoMaploc, this.geoMapno, this.geoTypeCode, this.geoTel});

  GetMasterVillageCondoGeoList.fromJson(Map<String, dynamic> json) {
    geoID = json['geoID'];
    geoNameTH = json['geoNameTh'];
    geoNameEN = json['geonameEn'];
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
    geoTypeCode = json['geoTypeCode'];
    geoTel = json['geoTel'];
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

    return data;
  }
}
