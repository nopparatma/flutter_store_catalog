part of 'sales_cart_bloc.dart';

@immutable
abstract class SalesCartEvent {}

class SalesCartUpdateStateModelEvent extends SalesCartEvent {
  final SalesCartDto salesCartDto;

  SalesCartUpdateStateModelEvent(this.salesCartDto);
}

class SalesCartResetEvent extends SalesCartEvent {}

class SalesCartLoadEvent extends SalesCartEvent {}

class SalesCartDeleteItemEvent extends SalesCartEvent {
  final SalesCartItem salesCartItem;
  SalesCartDeleteItemEvent(this.salesCartItem);
}
