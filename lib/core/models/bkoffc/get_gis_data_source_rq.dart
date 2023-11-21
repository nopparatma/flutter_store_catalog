class GetGisDataSourceRq {
  String geoDesc;
  String geoSoi;
  String geoStreet;
  String geoProv;
  String geoID;
  List<GeoType> geoType;

  GetGisDataSourceRq(
      {this.geoDesc,
        this.geoSoi,
        this.geoStreet,
        this.geoProv,
        this.geoID,
        this.geoType});

  GetGisDataSourceRq.fromJson(Map<String, dynamic> json) {
    geoDesc = json['geoDesc'];
    geoSoi = json['geoSoi'];
    geoStreet = json['geoStreet'];
    geoProv = json['geoProv'];
    geoID = json['geoID'];
    if (json['geoType'] != null) {
      geoType = new List<GeoType>();
      json['geoType'].forEach((v) {
        geoType.add(new GeoType.fromJson(v));
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
    if (this.geoType != null) {
      data['geoType'] = this.geoType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeoType {
  String geoTypeCode;

  GeoType({this.geoTypeCode});

  GeoType.fromJson(Map<String, dynamic> json) {
    geoTypeCode = json['geoTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geoTypeCode'] = this.geoTypeCode;
    return data;
  }
}