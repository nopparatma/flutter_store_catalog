import 'package:flutter_store_catalog/core/models/bkoffc/special_condition_item.dart';

class GetSpecialConditionItemRs {
  List<SpecialConditionItem> specialConditionItemBos;

  GetSpecialConditionItemRs({this.specialConditionItemBos});

  GetSpecialConditionItemRs.fromJson(Map<String, dynamic> json) {
    if (json['specialConditionItemBos'] != null) {
      specialConditionItemBos = new List<SpecialConditionItem>();
      json['specialConditionItemBos'].forEach((v) {
        specialConditionItemBos.add(new SpecialConditionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specialConditionItemBos != null) {
      data['specialConditionItemBos'] =
          this.specialConditionItemBos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
