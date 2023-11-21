import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/customer_service.dart';
import 'package:meta/meta.dart';

part 'search_customer_by_oid_event.dart';

part 'search_customer_by_oid_state.dart';

class SearchCustomerByOidBloc extends Bloc<SearchCustomerByOidEvent, SearchCustomerByOidState> {
  final CustomerService _customerService = getIt<CustomerService>();
  final ApplicationBloc applicationBloc;

  SearchCustomerByOidBloc(this.applicationBloc);
  @override
  SearchCustomerByOidState get initialState => InitialSearchCustomerByOidState();

  @override
  Stream<SearchCustomerByOidState> mapEventToState(SearchCustomerByOidEvent event) async* {
    // if (event is SearchCustomerPartnerBillToByOidEvent) {
    //   yield* mapSearchCustomerPartnerBillToByOidToState(event);
    // } else
    if (event is SearchCustomerByOidEvent) {
      yield* mapSearchCustomerByOidToState(event);
    }
    // TODO: Add your event logic
  }

  Stream<SearchCustomerByOidState> mapSearchCustomerByOidToState(SearchCustomerByOidEvent event) async* {
    try {
      yield LoadingGetCustomerByOidState();
      SearchCustomerByOidRq rq = new SearchCustomerByOidRq();

      rq.transactionDate = DateTime.now();//applicationBloc.state.appSession.transactionDateTime;
      rq.customerOid = event.customerOid;
      rq.store = applicationBloc.state.appSession.userProfile.storeId;

      AppSession appSession = applicationBloc.state.appSession;
      SearchCustomerByOidRs rs = await _customerService.searchCustomerByOid(appSession, rq);
      List<Customer> lsCustomerPartner = <Customer>[];
      rs.customer.customerPartners.forEach((element) {
        if (CustomerPartnerType.SHIP_TO == element.partnerFunctionTypeId && (CustomerPartnerType.SHIP_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerCustomer.partnerFunctionTypeId)) {
          lsCustomerPartner.add(element.partnerCustomer);
        }
      });
      yield SuccessGetCustomerByOidState(customerPartners: lsCustomerPartner);

    } catch (error, stackTrace) {
      yield ErrorGetCustomerByOidState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  // Stream<SearchCustomerByOidState> mapSearchCustomerPartnerBillToByOidToState(SearchCustomerPartnerBillToByOidEvent event) async* {
  //   try {
  //     yield LoadingGetCustomerByOidState();
  //     SearchCustomerByOidRq rq = new SearchCustomerByOidRq();
  //
  //     rq.transactionDate = applicationBloc.state.appSession.transactionDateTime;
  //     rq.customerOid = event.customerOid;
  //     rq.store = applicationBloc.state.appSession.userProfile.storeId;
  //
  //     SearchCustomerByOidRs rs = await _customerService.searchCustomerByOid(applicationBloc.state.appSession, rq);
  //     List<Customer> lsCustomerPartner = new List<Customer>();
  //     rs.customer.customerPartners.forEach((element) {
  //       if (CustomerPartnerType.BILL_TO == element.partnerFunctionTypeId) {
  //         lsCustomerPartner.add(element.partnerCustomer);
  //       }
  //     });
  //     yield SuccessGetCustomerByOidState(customerPartners: lsCustomerPartner);
  //
  //     //if (_salesCartReserveBloc.state.salesCartReserve != null) _salesCartReserveBloc.state.salesCartReserve.soldto = rs.customer;
  //   } catch (error, stackTrace) {
  //     yield ErrorGetCustomerByOidState(error: AppException(error, stackTrace: stackTrace));
  //   }
  // }
}
