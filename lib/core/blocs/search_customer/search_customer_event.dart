part of 'search_customer_bloc.dart';

@immutable
abstract class SearchCustomerEvent {}

class SearchCustomerSearchEvent  extends SearchCustomerEvent{
  final String searchCondition;
  final String searchValue;
  final String searchFirstName;
  final String searchLastName;
  final num pageSize;
  final String partnerTypeId;
  SearchCustomerSearchEvent({this.searchCondition, this.searchValue, this.searchFirstName, this.searchLastName, this.pageSize, this.partnerTypeId});
  @override
  String toString() {
    // TODO: implement toString
    return 'SearchCustomerEvent ${searchCondition} ${searchValue} ${searchFirstName} ${searchLastName} ${partnerTypeId}';
  }
}

class ResetSearchCustomerEvent extends SearchCustomerEvent {}

class SendOtpEvent extends SearchCustomerEvent {
  final String telephoneNo;

  SendOtpEvent({this.telephoneNo});
}

class ValidateOtpEvent extends SearchCustomerEvent {
  final String telephoneNo;
  final String otpSMSId;
  final String otpId;
  final String otpCode;

  ValidateOtpEvent({this.telephoneNo, this.otpSMSId, this.otpId, this.otpCode});

}