import 'package:flutter_store_catalog/core/models/bkoffc/special_condition_item.dart';

class GetSpecialConditionItemRq {
  List<SpecialConditionItem> specialConditionItemBos;
  String storeId;

  GetSpecialConditionItemRq({this.specialConditionItemBos, this.storeId});

  GetSpecialConditionItemRq.fromJson(Map<String, dynamic> json) {
    if (json['specialConditionItemBos'] != null) {
      specialConditionItemBos = <SpecialConditionItem>[];
      json['specialConditionItemBos'].forEach((v) {
        specialConditionItemBos.add(new SpecialConditionItem.fromJson(v));
      });
    }
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specialConditionItemBos != null) {
      data['specialConditionItemBos'] =
          this.specialConditionItemBos.map((v) => v.toJson()).toList();
    }
    data['storeId'] = this.storeId;
    return data;
  }
}
