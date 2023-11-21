part of 'search_customer_by_oid_bloc.dart';

@immutable
abstract class SearchCustomerByOidState {}

class InitialSearchCustomerByOidState extends SearchCustomerByOidState {}
class LoadingGetCustomerByOidState extends SearchCustomerByOidState {
  @override
  String toString() {
    return 'LoadingGetCustomerByOidState';
  }
}

class ErrorGetCustomerByOidState extends SearchCustomerByOidState {
  final dynamic error;
  ErrorGetCustomerByOidState({this.error});
  @override
  String toString() {
    return 'ErrorGetCustomerByOidState{error: $error}';
  }
}

class SuccessGetCustomerByOidState extends SearchCustomerByOidState {
  final List<Customer> customerPartners;
  SuccessGetCustomerByOidState({this.customerPartners});

  @override
  String toString() {
    return 'SuccessGetCustomerByOidState';
  }
}