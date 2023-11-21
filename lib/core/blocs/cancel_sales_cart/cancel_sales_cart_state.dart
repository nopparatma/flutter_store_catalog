part of 'cancel_sales_cart_bloc.dart';

@immutable
abstract class CancelSalesCartState {}

class InitialCancelSalesCartState extends CancelSalesCartState {}

class LoadingCancelSalesCartState extends CancelSalesCartState {
  @override
  String toString() {
    return 'LoadingCancelSalesCartState{}';
  }
}

class ErrorCancelSalesCartState extends CancelSalesCartState {
  final dynamic error;

  ErrorCancelSalesCartState({this.error});

  @override
  String toString() {
    return 'ErrorCancelSalesCartState{error: $error}';
  }
}

class SuccessCancelSalesCartState extends CancelSalesCartState {
  @override
  String toString() {
    return 'SuccessCancelSalesCartState{}';
  }
}
