part of 'sales_cart_bloc.dart';

class SalesCartState {
  SalesCartDto salesCartDto;
  SalesCartReserve salesCartReserve;

  SalesCartState({this.salesCartDto, this.salesCartReserve});
}

class LoadingSalesCartState extends SalesCartState {
  @override
  String toString() {
    return 'LoadingSalesCartState{}';
  }
}

class ErrorSalesCartState extends SalesCartState {
  final dynamic error;

  ErrorSalesCartState({this.error});

  @override
  String toString() {
    return 'ErrorSalesCartState{error: $error}';
  }
}
