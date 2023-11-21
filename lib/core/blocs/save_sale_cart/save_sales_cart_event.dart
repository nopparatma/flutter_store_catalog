part of 'save_sales_cart_bloc.dart';

@immutable
abstract class SaveSalesCartEvent {}

class SaveSalesCartWithPhoneNoEvent extends SaveSalesCartEvent {
  final String phoneNo;
  final SalesCart salesCart;

  SaveSalesCartWithPhoneNoEvent(this.phoneNo, {this.salesCart});

  @override
  String toString() {
    return 'SaveSalesCartWithPhoneNoEvent{phoneNo: $phoneNo, salesCart: $salesCart}';
  }
}

class SaveSalesCartWithCustomerEvent extends SaveSalesCartEvent {
  final Customer customer;
  final SalesCart salesCart;

  SaveSalesCartWithCustomerEvent(this.customer, {this.salesCart});

  @override
  String toString() {
    return 'SaveSalesCartWithCustomerEvent{customer: $customer, salesCart: $salesCart}';
  }
}

class SalesCartUpdateCustomerEvent extends SaveSalesCartEvent{
  final num salesCartOid;
  final Customer customer;

  SalesCartUpdateCustomerEvent(this.salesCartOid, this.customer);
}