part of 'search_customer_bloc.dart';

@immutable
abstract class SearchCustomerState {}

class InitialSearchCustomerState extends SearchCustomerState {}

class LoadingSearchCustomerByState extends SearchCustomerState {
  @override
  String toString() {
    return 'LoadingSearchSalesCartState';
  }
}

class ErrorSearchCustomerByState extends SearchCustomerState {
  final dynamic error;
  ErrorSearchCustomerByState({this.error});
  @override
  String toString() {
    return 'ErrorSearchSalesCartState{error: $error}';
  }
}

class SuccessSearchByCustomerByState extends SearchCustomerState {
  final List<Customer> customers;
  final String searchValue;
  SuccessSearchByCustomerByState(this.customers, {this.searchValue});

  @override
  String toString() {
    return 'SuccessSearchByCustomerByState{customers: $customers}';
  }
}

class VerifyOTPSuccessState extends SearchCustomerState {

  @override
  String toString() {
    return 'VerifyOTPSuccessState{}';
  }
}

class CustomerNotFoundState extends SearchCustomerState{
  final String phoneNo;

  CustomerNotFoundState({this.phoneNo});

  @override
  String toString() {
    return 'CustomerNotFoundState{}';
  }
}

class InitialOtpState extends SearchCustomerState {}

class LoadingOtpState extends SearchCustomerState {}

class ErrorOtpState extends SearchCustomerState {
  final error;
  ErrorOtpState(this.error);
}

class SuccesSendOtpState extends SearchCustomerState {
  final String otpSMSId;
  final String otpId;
  final int timeoutInSecond;
  final String refCode;

  SuccesSendOtpState({this.otpSMSId, this.otpId, this.timeoutInSecond, this.refCode});
}

class SuccesValidateOtpState extends SearchCustomerState {}
