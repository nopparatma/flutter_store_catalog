part of 'save_sales_cart_bloc.dart';

@immutable
abstract class SaveSalesCartState {}

class InitialSaveSalesCartState extends SaveSalesCartState {}

class SaveSalesWithCustomerSuccessState extends SaveSalesCartState {
  final num salesCartOid;
  final bool isScatException;

  SaveSalesWithCustomerSuccessState(this.salesCartOid, this.isScatException);

  @override
  String toString() {
    return 'SaveSalesWithCustomerSuccessState{salesCartOid: $salesCartOid}';
  }
}

class SaveSalesWithPhoneSuccessState extends SaveSalesCartState {
  final num salesCartOid;
  final String phoneNo;

  SaveSalesWithPhoneSuccessState(this.salesCartOid, this.phoneNo);

  @override
  String toString() {
    return 'SaveSalesWithPhoneSuccessState{salesCartOid: $salesCartOid, phoneNo: $phoneNo}';
  }
}

class SaveSalesCartLoadingState extends SaveSalesCartState {
  String toString() => 'SaveSalesCartLoadingState';
}

class SaveSalesCartErrorState extends SaveSalesCartState {
  final dynamic error;

  SaveSalesCartErrorState(this.error);

  String toString() => 'SaveSalesCartErrorState';
}

class SalesCartUpdateCustomerSuccessState extends SaveSalesCartState{
  final num salesCartOid;

  SalesCartUpdateCustomerSuccessState(this.salesCartOid);

  @override
  String toString() {
    return 'SalesCartUpdateCustomerSuccessState{salesCartOid: $salesCartOid}';
  }
}