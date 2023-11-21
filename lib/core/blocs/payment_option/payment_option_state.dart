part of 'payment_option_bloc.dart';

class PaymentOptionDataState extends Equatable {
  final List<MemberCard> memberCards;
  final SimPayDiscountBo simulatePaymentStoreDiscountBo;
  final CardDataList customerCardBurnpoint;
  final List<TriggerCoupon> listTriggerCouponPromotion;

  PaymentOptionDataState({this.memberCards, this.simulatePaymentStoreDiscountBo, this.customerCardBurnpoint, this.listTriggerCouponPromotion});

  @override
  String toString() {
    return 'PaymentOptionDataState{memberCards: $memberCards, simulatePaymentStoreDiscountBo: $simulatePaymentStoreDiscountBo, customerCardBurnpoint: $customerCardBurnpoint, listTriggerCouponPromotion: $listTriggerCouponPromotion}';
  }

  @override
  List<Object> get props => [simulatePaymentStoreDiscountBo, customerCardBurnpoint, listTriggerCouponPromotion.length, memberCards?.length ?? 0];
}
