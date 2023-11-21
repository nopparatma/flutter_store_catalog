class GetBrandCategoryRq {
  String brandId;

  GetBrandCategoryRq({this.brandId});

  GetBrandCategoryRq.fromJson(Map<String, dynamic> json) {
    brandId = json['BrandId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandId'] = this.brandId;
    return data;
  }
}
