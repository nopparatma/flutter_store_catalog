part of 'hire_purchase_bloc.dart';

@immutable
abstract class HirePurchaseState {}

class InitialHirePurchaseState extends HirePurchaseState {}

class LoadingHirePurchaseState extends HirePurchaseState {}

class ResetHirePurchaseState extends HirePurchaseState {}

class ShowPromotionHirePurchaseState extends HirePurchaseState {
  final String hirePurchaseState;
  final Map<String, List<HirePurchasePromotion>> groupPromotionMap;
  final bool canBack;
  final bool canNext;

  ShowPromotionHirePurchaseState({this.hirePurchaseState, this.groupPromotionMap, this.canBack, this.canNext});

  @override
  String toString() {
    return 'ShowPromotionHirePurchaseState{hirePurchaseState: $hirePurchaseState, groupPromotionMap: $groupPromotionMap, canNext: $canNext}';
  }
}

class ConfirmedPromotionState extends HirePurchaseState {

  final CalculatePromotionCARs calcRs;
  final List<String> notHavePromotionList;

  ConfirmedPromotionState(this.calcRs, this.notHavePromotionList);

  @override
  String toString() {
    return 'ConfirmedPromotionState';
  }
}

class ErrorHirePurchaseState extends HirePurchaseState {
  final error;

  ErrorHirePurchaseState(this.error);

  @override
  String toString() {
    return 'ErrorHirePurchaseState{error: $error}';
  }
}
