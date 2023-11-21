part of 'create_sales_bloc.dart';

@immutable
abstract class CreateSalesState {}

class InitialCreateSalesState extends CreateSalesState {
  @override
  String toString() {
    return 'InitialCreateSalesState{}';
  }
}

class LoadingCreateSalesState extends CreateSalesState {
  LoadingCreateSalesState();
}

class ErrorCreateSalesState extends CreateSalesState {
  final dynamic error;

  ErrorCreateSalesState({this.error});

  @override
  String toString() {
    return 'ErrorCreateSalesState{error: $error}';
  }
}

class SuccessSmsCreateSalesState extends CreateSalesState {}

class SuccessQRCreateSalesState extends CreateSalesState {
  final String qrImage;

  SuccessQRCreateSalesState(this.qrImage);

  @override
  String toString() {
    return 'SuccessQRCreateSalesState';
  }
}

class TimeoutQRCreateSalesState extends CreateSalesState {

  @override
  String toString() {
    return 'TimeoutQRCreateSalesState';
  }
}

class SuccessQRPaymentState extends CreateSalesState {
  final String posId;
  final String ticketNo;
  final String totalPrice;

  SuccessQRPaymentState({this.posId, this.ticketNo, this.totalPrice});

  @override
  String toString() {
    return 'SuccessQRPaymentState{posId: $posId, ticketNo: $ticketNo, totalPrice: $totalPrice}';
  }

}

class SuccessCreateCollectSalesState extends CreateSalesState {}