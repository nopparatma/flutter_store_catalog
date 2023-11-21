part of 'calculate_promotion_bloc.dart';

@immutable
abstract class CalculatePromotionEvent {}

class StartCalculatePromotionEvent extends CalculatePromotionEvent {
  final String appId;
  final MstMbrCardGroupDet discountCard;

  StartCalculatePromotionEvent(this.appId, {this.discountCard});

  @override
  String toString() {
    return 'StartCalculatePromotionEvent{appId: $appId, discountCard: $discountCard}';
  }
}

class SelectCalculatePromotionEvent extends CalculatePromotionEvent {
  final String appId;
  final num totalAmount;
  final SuggestTender suggestTender;

  SelectCalculatePromotionEvent({this.appId, this.totalAmount, this.suggestTender});

  @override
  String toString() {
    return 'SelectCalculatePromotionEvent{appId: $appId, totalAmount: $totalAmount, suggestTender: $suggestTender}';
  }
}

class StartCheckPriceEvent extends CalculatePromotionEvent {
  final String appId;
  final List<SalesItem> salesItems;

  StartCheckPriceEvent(this.appId, this.salesItems);

  @override
  String toString() {
    return 'StartCheckPriceEvent{appId: $appId, salesItems: $salesItems}';
  }
}

class CalculateHirePurchaseEvent extends CalculatePromotionEvent {
  final String appId;
  final num totalAmount;
  final SuggestTender suggestTender;

  CalculateHirePurchaseEvent({this.appId, this.totalAmount, this.suggestTender});

  @override
  String toString() {
    return 'CalculateHirePurchaseEvent{appId: $appId, suggestTender: $suggestTender}';
  }
}
