part of 'search_customer_by_oid_bloc.dart';

class SearchCustomerByOidEvent {
  final num customerOid;
  SearchCustomerByOidEvent({this.customerOid});
  @override
  String toString() {
    // TODO: implement toString
    return 'SearchCustomerByOidEvent ${this.customerOid}';
  }
}

class SearchCustomerPartnerBillToByOidEvent extends SearchCustomerByOidEvent {
  final num customerOid;

  SearchCustomerPartnerBillToByOidEvent({this.customerOid});
  @override
  String toString() {
    // TODO: implement toString
    return 'SearchCustomerPartnerBillToByOid ${this.customerOid}';
  }
}
