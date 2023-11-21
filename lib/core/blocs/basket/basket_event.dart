part of 'basket_bloc.dart';

@immutable
abstract class BasketEvent {}

class BasketAddItemEvent extends BasketEvent {
  final BasketItem item;
  final bool isPopWidget;

  BasketAddItemEvent(this.item, this.isPopWidget);

  @override
  String toString() {
    return 'BasketAddItemEvent{item: $item}';
  }
}

class BasketRemoveItemEvent extends BasketEvent {
  final BasketItem item;

  BasketRemoveItemEvent(this.item);

  @override
  String toString() {
    return 'BasketRemoveItemEvent{item: $item}';
  }
}

class BasketUpdateItemEvent extends BasketEvent {
  final BasketItem item;
  final num newQty;

  BasketUpdateItemEvent(this.item, this.newQty);

  @override
  String toString() {
    return 'BasketUpdateItemEvent{item: $item, newQty: $newQty}';
  }
}

class BasketUpdateItemCheckListEvent extends BasketEvent {
  final BasketItem item;
  final CheckListData checkListData;

  BasketUpdateItemCheckListEvent(this.item, this.checkListData);

  @override
  String toString() {
    return 'BasketUpdateItemCheckListEvent{item: $item, checkListData: $checkListData}';
  }
}

class ResetBasketEvent extends BasketEvent{
  @override
  String toString() {
    return 'ResetBasketEvent';
  }
}