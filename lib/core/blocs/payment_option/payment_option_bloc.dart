import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_search_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/member_card.dart';
import 'package:flutter_store_catalog/core/models/view/trigger_coupon.dart';
import 'package:meta/meta.dart';

part 'payment_option_event.dart';

part 'payment_option_state.dart';

class PaymentOptionBloc extends Bloc<PaymentOptionEvent, PaymentOptionDataState> {
  @override
  PaymentOptionDataState get initialState => PaymentOptionDataState(listTriggerCouponPromotion: []);

  @override
  Stream<PaymentOptionDataState> mapEventToState(PaymentOptionEvent event) async* {
    if (event is ChooseMemberCardEvent) {
      yield* mapChooseMemberCardEventToState(event);
    } else if (event is RemoveMemberCardEvent) {
      yield* mapRemoveMemberCardEventToState(event);
    } else if (event is ChooseCustomerCardBurnpoint) {
      yield* mapChooseCustomerCardBurnpointEventToState(event);
    } else if (event is AddDiscountFullBillEvent) {
      yield* mapAddDiscountFullBillEventToState(event);
    } else if (event is UpdatePaymentOptionEvent) {
      yield PaymentOptionDataState(
        simulatePaymentStoreDiscountBo: event.simulatePaymentStoreDiscountBo ?? state.simulatePaymentStoreDiscountBo,
        customerCardBurnpoint: event.customerCardBurnpoint ?? state.customerCardBurnpoint,
        memberCards: event.memberCards ?? state.memberCards,
        listTriggerCouponPromotion: event.listTriggerCouponPromotion ?? state.listTriggerCouponPromotion,
      );
    } else if (event is RemoveDiscountFullBillEvent) {
      yield PaymentOptionDataState(
        simulatePaymentStoreDiscountBo: null,
        customerCardBurnpoint: state.customerCardBurnpoint,
        memberCards: state.memberCards,
        listTriggerCouponPromotion: state.listTriggerCouponPromotion,
      );
    } else if (event is ResetPaymentOptionEvent) {
      yield PaymentOptionDataState(
        simulatePaymentStoreDiscountBo: null,
        customerCardBurnpoint: null,
        memberCards: null,
        listTriggerCouponPromotion: [],
      );
    }
  }

  Stream<PaymentOptionDataState> mapChooseMemberCardEventToState(ChooseMemberCardEvent event) async* {
    if (event.memberCard == null) {
      return;
    }

    if (state is! PaymentOptionDataState) {
      List<MemberCard> memberCards = List();
      memberCards.add(event.memberCard);
      yield PaymentOptionDataState(
        memberCards: memberCards,
        customerCardBurnpoint: state.customerCardBurnpoint,
        listTriggerCouponPromotion: state.listTriggerCouponPromotion,
        simulatePaymentStoreDiscountBo: state.simulatePaymentStoreDiscountBo,
      );
    } else if (state is PaymentOptionDataState) {
      PaymentOptionDataState paymentOptionDataState = state as PaymentOptionDataState;

      List<MemberCard> memberCards = paymentOptionDataState.memberCards;
      MemberCard newMemberCard = event.memberCard;

      if (memberCards.where((element) => (element.paymentOptionId == newMemberCard.paymentOptionId && element.id == newMemberCard.id)).toList().isEmpty) {
        memberCards.add(event.memberCard);
      }

      yield PaymentOptionDataState(
        memberCards: memberCards,
        listTriggerCouponPromotion: state.listTriggerCouponPromotion,
        customerCardBurnpoint: state.customerCardBurnpoint,
        simulatePaymentStoreDiscountBo: state.simulatePaymentStoreDiscountBo,
      );
    }
  }

  Stream<PaymentOptionDataState> mapRemoveMemberCardEventToState(RemoveMemberCardEvent event) async* {
    if (event.memberCard == null) {
      return;
    }

    if (state is! PaymentOptionDataState) {
      return;
    }

    PaymentOptionDataState paymentOptionDataState = state as PaymentOptionDataState;

    List<MemberCard> memberCards = paymentOptionDataState.memberCards;
    MemberCard removeMemberCard = event.memberCard;

    memberCards.removeWhere((element) => (element.paymentOptionId == removeMemberCard.paymentOptionId && element.id == removeMemberCard.id));

    yield PaymentOptionDataState(
      memberCards: memberCards,
      listTriggerCouponPromotion: state.listTriggerCouponPromotion,
      customerCardBurnpoint: state.customerCardBurnpoint,
      simulatePaymentStoreDiscountBo: state.simulatePaymentStoreDiscountBo,
    );
  }

  Stream<PaymentOptionDataState> mapChooseCustomerCardBurnpointEventToState(ChooseCustomerCardBurnpoint event) async* {
    if (event.customerCardBurnPoint == null) {
      return;
    }

    if (state is! PaymentOptionDataState) {
      yield PaymentOptionDataState(customerCardBurnpoint: event.customerCardBurnPoint);
    } else if (state is PaymentOptionDataState) {
      PaymentOptionDataState paymentOptionDataState = state as PaymentOptionDataState;

      yield PaymentOptionDataState(
        customerCardBurnpoint: event.customerCardBurnPoint,
        listTriggerCouponPromotion: state.listTriggerCouponPromotion,
        simulatePaymentStoreDiscountBo: state.simulatePaymentStoreDiscountBo,
        memberCards: state.memberCards,
      );
    }
  }

  Stream<PaymentOptionDataState> mapAddDiscountFullBillEventToState(AddDiscountFullBillEvent event) async* {
    if (event.simPayDiscountBo == null) {
      return;
    }
    PaymentOptionDataState paymentOptionDataState = state as PaymentOptionDataState;
    SimPayDiscountBo simPayDiscountBo = paymentOptionDataState.simulatePaymentStoreDiscountBo;
    simPayDiscountBo = event.simPayDiscountBo;

    if (state is! PaymentOptionDataState) {
      yield PaymentOptionDataState(
        simulatePaymentStoreDiscountBo: simPayDiscountBo,
        listTriggerCouponPromotion: state.listTriggerCouponPromotion,
        customerCardBurnpoint: state.customerCardBurnpoint,
        memberCards: state.memberCards,
      );
    } else if (state is PaymentOptionDataState) {
      PaymentOptionDataState paymentOptionDataState = state as PaymentOptionDataState;
      yield PaymentOptionDataState(
        simulatePaymentStoreDiscountBo: simPayDiscountBo,
        listTriggerCouponPromotion: state.listTriggerCouponPromotion,
        customerCardBurnpoint: state.customerCardBurnpoint,
        memberCards: state.memberCards,
      );
    }
  }
}
