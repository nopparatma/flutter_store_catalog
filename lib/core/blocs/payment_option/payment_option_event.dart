part of 'payment_option_bloc.dart';

@immutable
abstract class PaymentOptionEvent {}

class ChooseMemberCardEvent extends PaymentOptionEvent {
  final MemberCard memberCard;

  ChooseMemberCardEvent(this.memberCard);
}

class RemoveMemberCardEvent extends PaymentOptionEvent {
  final MemberCard memberCard;

  RemoveMemberCardEvent(this.memberCard);
}

class ChooseCustomerCardBurnpoint extends PaymentOptionEvent {
  final CardDataList customerCardBurnPoint;

  ChooseCustomerCardBurnpoint(this.customerCardBurnPoint);
}

class AddDiscountFullBillEvent extends PaymentOptionEvent {
  final SimPayDiscountBo simPayDiscountBo;

  AddDiscountFullBillEvent({this.simPayDiscountBo});
}

class UpdatePaymentOptionEvent extends PaymentOptionEvent {
  final List<MemberCard> memberCards;
  final SimPayDiscountBo simulatePaymentStoreDiscountBo;
  final CardDataList customerCardBurnpoint;
  final List<TriggerCoupon> listTriggerCouponPromotion;

  UpdatePaymentOptionEvent({this.memberCards, this.simulatePaymentStoreDiscountBo, this.customerCardBurnpoint, this.listTriggerCouponPromotion});

  @override
  String toString() {
    return 'UpdatePaymentOptionEvent{memberCards: $memberCards, simulatePaymentStoreDiscountBo: $simulatePaymentStoreDiscountBo, customerCardBurnpoint: $customerCardBurnpoint, listTriggerCouponPromotion: $listTriggerCouponPromotion}';
  }
}

class RemoveDiscountFullBillEvent extends PaymentOptionEvent {}

class ResetPaymentOptionEvent extends PaymentOptionEvent {}