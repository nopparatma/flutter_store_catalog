part of 'hire_purchase_bloc.dart';

@immutable
abstract class HirePurchaseEvent {}

class SelectBankHirePurchaseEvent extends HirePurchaseEvent {
  final HirePurchaseDto hirePurchaseDto;

  SelectBankHirePurchaseEvent({this.hirePurchaseDto});

  @override
  String toString() {
    return 'SelectBankHirePurchaseEvent{hirePurchaseDto: $hirePurchaseDto}';
  }
}

class BackPageHirePurchaseEvent extends HirePurchaseEvent {
  final MstBank selectBank;
  final String currentState;
  final HirePurchaseDto hirePurchaseDto;
  final Map<String, HirePurchasePromotion> selectPromotion;

  BackPageHirePurchaseEvent({this.selectBank, this.currentState, this.hirePurchaseDto, this.selectPromotion});

  @override
  String toString() {
    return 'BackPageHirePurchaseEvent{currentState: $currentState, hirePurchaseDto: $hirePurchaseDto}';
  }
}

class NextPageHirePurchaseEvent extends HirePurchaseEvent {
  final MstBank selectBank;
  final String currentState;
  final HirePurchaseDto hirePurchaseDto;
  final Map<String, HirePurchasePromotion> selectPromotion;

  NextPageHirePurchaseEvent({this.selectBank, this.currentState, this.hirePurchaseDto, this.selectPromotion});

  @override
  String toString() {
    return 'NextPageHirePurchaseEvent{currentState: $currentState, hirePurchaseDto: $hirePurchaseDto}';
  }
}

class SelectPromotionEvent extends HirePurchaseEvent {
  final MstBank selectBank;
  final String hirePurchaseState;
  final Map<String, List<HirePurchasePromotion>> groupPromotionMap;
  final Map<String, HirePurchasePromotion> selectPromotion;

  SelectPromotionEvent({this.selectBank, this.hirePurchaseState, this.groupPromotionMap, this.selectPromotion});

  @override
  String toString() {
    return 'SelectPromotionEvent{selectBank: $selectBank, hirePurchaseState: $hirePurchaseState, groupPromotionMap: $groupPromotionMap, selectPromotion: $selectPromotion}';
  }
}

class ConfirmPromotionEvent extends HirePurchaseEvent {
  final MstBank selectBank;
  final String hirePurchaseState;
  final CalculatePromotionCARs calculatePromotionCARs;
  final Map<String, HirePurchasePromotion> selectPromotion;

  ConfirmPromotionEvent({this.selectBank, this.hirePurchaseState, this.calculatePromotionCARs, this.selectPromotion});

  @override
  String toString() {
    return 'SelectPromotionEvent{selectBank: $selectBank, hirePurchaseState: $hirePurchaseState, selectPromotion: $selectPromotion}';
  }
}

// class SelectHirePurchasePromotionEvent extends HirePurchaseEvent {
//   final CalproViewModel calproViewModel;
//   final String currentState;
//   final HirePurchasePromotion selectHirePurchase;
//
//   SelectHirePurchasePromotionEvent({this.calproViewModel, this.currentState, this.selectHirePurchase});
//
//   @override
//   String toString() {
//     return 'SelectHirePurchasePromotionEvent{calproViewModel: $calproViewModel, currentState: $currentState, selectHirePurchase: $selectHirePurchase}';
//   }
// }
//
// class CheckProTenderHirePurchaseEvent extends HirePurchaseEvent {
//   final CalculatePromotionCARq calculatePromotionCARq;
//   final CalculatePromotionCARs calculatePromotionCARs;
//   final CalproViewModel calproViewModel;
//
//   CheckProTenderHirePurchaseEvent(this.calculatePromotionCARq, this.calculatePromotionCARs, this.calproViewModel);
//
//   @override
//   String toString() {
//     return 'CheckProTenderHirePurchaseEvent{calculatePromotionCARq: $calculatePromotionCARq, calculatePromotionCARs: $calculatePromotionCARs, calproViewModel: $calproViewModel}';
//   }
// }

class ResetHirePurchaseEvent extends HirePurchaseEvent {
  @override
  String toString() {
    return 'ResetHirePurchaseEvent';
  }
}

class InitHirePurchaseEvent extends HirePurchaseEvent {
  @override
  String toString() {
    return 'InitHirePurchaseEvent';
  }
}

// class ShowCheckPriceHirePurchaseEvent extends HirePurchaseEvent {
//   final CalproViewModel calproViewModel;
//
//   ShowCheckPriceHirePurchaseEvent({this.calproViewModel});
//
//   @override
//   String toString() {
//     return 'ShowCheckPriceHirePurchaseEvent{calproViewModel: $calproViewModel}';
//   }
// }
