import 'dart:ui';

class MenuDto {
  String MCHID;
  String MCHNameTH;
  String MCHNameEN;
  String MCHImgUrl;
  List<MenuDto> MCHList;
  TemplateBoxModel templateBoxModel;
  MenuDto({this.MCHID, this.MCHNameTH, this.MCHNameEN, this.MCHImgUrl, this.MCHList, this.templateBoxModel});

  @override
  String toString() {
    return 'Menu{name: $MCHNameTH}';
  }
}

class TemplateBoxModel {
  final Color color;
  final int columnCellCount;
  final int rowCellCount;

  const TemplateBoxModel(this.color, this.columnCellCount, this.rowCellCount);
}
