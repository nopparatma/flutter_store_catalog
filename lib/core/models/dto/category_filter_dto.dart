class CategoryFilterHeaderDto {
  String featureCode;
  String featureNameEN;
  String featureNameTH;
  List<CategoryFilterChildDto> childCategoryList;

  CategoryFilterHeaderDto({this.featureCode, this.featureNameEN, this.featureNameTH, this.childCategoryList});
}

class CategoryFilterChildDto {
  String featureCode;
  String featureNameEn;
  String featureNameTH;
  String featureDescTH;
  String featureDescEN;

  //DISPLAY
  bool isSelected = false;

  CategoryFilterChildDto({this.featureCode, this.featureNameEn, this.featureNameTH, this.featureDescTH, this.featureDescEN});
}
