part of 'cancel_sales_cart_bloc.dart';

@immutable
abstract class CancelSalesCartEvent {}

class CancelSalesCartItemEvent extends CancelSalesCartEvent {

  @override
  String toString() {
    return 'CancelSalesCartItemEvent{}';
  }
}

class CancelSalesOrderEvent extends CancelSalesCartEvent {

  @override
  String toString() {
    return 'CancelSalesOrderEvent{}';
  }
}
