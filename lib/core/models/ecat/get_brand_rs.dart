class GetBrandRs {
  List<BrandList> brandList;

  GetBrandRs({this.brandList});

  GetBrandRs.fromJson(Map<String, dynamic> json) {
    if (json['BrandList'] != null) {
      brandList = new List<BrandList>();
      json['BrandList'].forEach((v) {
        brandList.add(new BrandList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brandList != null) {
      data['BrandList'] = this.brandList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandList {
  String seq;
  String brandId;
  String brandNameTH;
  String brandNameEN;
  String brandImgUrl;
  String searchTerm;

  BrandList({this.seq, this.brandId, this.brandNameTH, this.brandNameEN, this.brandImgUrl, this.searchTerm});

  BrandList.fromJson(Map<String, dynamic> json) {
    seq = json['Seq'];
    brandId = json['BrandId'];
    brandNameTH = json['BrandNameTH'];
    brandNameEN = json['BrandNameEN'];
    brandImgUrl = json['BrandImgUrl'];
    searchTerm = json['SearchTerm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Seq'] = this.seq;
    data['BrandId'] = this.brandId;
    data['BrandNameTH'] = this.brandNameTH;
    data['BrandNameEN'] = this.brandNameEN;
    data['BrandImgUrl'] = this.brandImgUrl;
    data['SearchTerm'] = this.searchTerm;
    return data;
  }
}
