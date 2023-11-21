import 'package:equatable/equatable.dart';

class TriggerCoupon extends Equatable {
  String couponNo;
  String promotionId;
  String promotionDesc;
  String promotionName;

  TriggerCoupon({this.couponNo,this.promotionDesc, this.promotionId, this.promotionName});

  @override
  String toString() {
    return 'TriggerCoupon{couponNo: $couponNo, promotionId: $promotionId, promotionDesc: $promotionDesc, promotionName: $promotionName}';
  }

  @override
  List<Object> get props => [promotionId];
}