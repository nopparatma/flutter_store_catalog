part of 'create_customer_bloc.dart';

@immutable
abstract class CreateCustomerState {}

class InitialCreateCustomerState extends CreateCustomerState {}

class LoadingCreateCustomerState extends CreateCustomerState {

  @override
  String toString() {
    return 'LoadingCreateCustomerState{}';
  }
}

class ErrorCreateCustomerState extends CreateCustomerState{
  final dynamic error;

  ErrorCreateCustomerState({this.error});

  @override
  String toString() {
    return 'ErrorCreateCustomerState{error: $error}';
  }
}

class CreateSoldToCustomerSuccessState extends CreateCustomerState{
  final Customer customer;

  CreateSoldToCustomerSuccessState(this.customer);

  @override
  String toString() {
    return 'CreateSoldToCustomerSuccessState{customer: $customer}';
  }
}

class CreateShipToCustomerSuccessState extends CreateCustomerState{
  final Customer customer;

  CreateShipToCustomerSuccessState(this.customer);

  @override
  String toString() {
    return 'CreateShipToCustomerSuccessState{customer: $customer}';
  }
}

class CreateBillToCustomerSuccessState extends CreateCustomerState{
  final Customer customer;

  CreateBillToCustomerSuccessState(this.customer);

  @override
  String toString() {
    return 'CreateBillToCustomerSuccessState';
  }
}
