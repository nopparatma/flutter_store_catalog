class GetMasterVillageCondoRq {
  String geoDesc;
  String geoSoi;
  String geoStreet;
  String geoProv;
  String geoID;
  num startRow;
  num pageSize;
  List<GetMasterVillageCondoGeoType> geoType;

  GetMasterVillageCondoRq(
      {this.geoDesc,
        this.geoSoi,
        this.geoStreet,
        this.geoProv,
        this.geoID,
        this.startRow,
        this.pageSize,
        this.geoType});

  GetMasterVillageCondoRq.fromJson(Map<String, dynamic> json) {
    geoDesc = json['geoDesc'];
    geoSoi = json['geoSoi'];
    geoStreet = json['geoStreet'];
    geoProv = json['geoProv'];
    geoID = json['geoID'];
    startRow = json['startRow'];
    pageSize = json['pageSize'];
    if (json['geoType'] != null) {
      geoType = new List<GetMasterVillageCondoGeoType>();
      json['geoType'].forEach((v) {
        geoType.add(new GetMasterVillageCondoGeoType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geoDesc'] = this.geoDesc;
    data['geoSoi'] = this.geoSoi;
    data['geoStreet'] = this.geoStreet;
    data['geoProv'] = this.geoProv;
    data['geoID'] = this.geoID;
    data['startRow'] = this.startRow;
    data['pageSize'] = this.pageSize;
    if (this.geoType != null) {
      data['geoType'] = this.geoType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetMasterVillageCondoGeoType {
  String geoTypeCode;

  GetMasterVillageCondoGeoType({this.geoTypeCode});

  GetMasterVillageCondoGeoType.fromJson(Map<String, dynamic> json) {
    geoTypeCode = json['geoTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geoTypeCode'] = this.geoTypeCode;
    return data;
  }
}