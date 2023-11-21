import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_billto_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_billto_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_shipto_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_shipto_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_soldto_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_soldto_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_customer_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/customer_service.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:meta/meta.dart';

part 'create_customer_event.dart';

part 'create_customer_state.dart';

class CreateCustomerBloc extends Bloc<CreateCustomerEvent, CreateCustomerState> {
  final CustomerService _customerService = getIt<CustomerService>();
  final ApplicationBloc applicationBloc;
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();

  CreateCustomerBloc(this.applicationBloc);

  @override
  CreateCustomerState get initialState => InitialCreateCustomerState();

  @override
  Stream<CreateCustomerState> mapEventToState(CreateCustomerEvent event) async* {
    if (event is CreateSoldToCustomerEvent) {
      yield* mapCreateSoldToCustomer(event);
    } else if (event is CreateShiptoCustomerEvent) {
      yield* mapCreateShipToCustomer(event);
    } else if (event is CreateBillToCustomerEvent) {
      yield* mapBillToCreateCustomer(event);
    }
  }

  Stream<CreateCustomerState> mapCreateShipToCustomer(CreateShiptoCustomerEvent event) async* {
    try {
      yield LoadingCreateCustomerState();

      CreateShiptoCustomerRq rq = new CreateShiptoCustomerRq();
      rq.shipToCustomerBo = new Customer();
      rq.shipToCustomerBo.transportData = new TransportData();

      rq.soldToCustomerOid = event.soldTo.customerOid;
      rq.soldToSapId = event.soldTo.sapId;
      rq.systemName = "SS";
      rq.screenName = "Create CustomerShipto";
      rq.companyCode = applicationBloc.state.appSession.userProfile.companyCode;
      rq.fromStore = applicationBloc.state.appSession.userProfile.storeId;
      rq.fromUser = applicationBloc.state.appSession.userProfile.empId;

      rq.shipToCustomerBo.type = "P";
      rq.shipToCustomerBo.firstName = event.soldTo.firstName;
      rq.shipToCustomerBo.lastName = event.soldTo.lastName;
      rq.shipToCustomerBo.number = event.number;
      rq.shipToCustomerBo.unit = event.unit;
      rq.shipToCustomerBo.floor = event.floor;
      rq.shipToCustomerBo.village = event.village;
      rq.shipToCustomerBo.moo = event.moo;
      rq.shipToCustomerBo.soi = event.soi;
      rq.shipToCustomerBo.street = event.street;
      rq.shipToCustomerBo.placeId = event.placeId;
      rq.shipToCustomerBo.subDistrict = event.subDistrict;
      rq.shipToCustomerBo.district = event.district;
      rq.shipToCustomerBo.province = event.province;
      rq.shipToCustomerBo.zipCode = event.zipcode;
      rq.shipToCustomerBo.phoneNumber1 = event.soldTo.phoneNumber1;
      rq.shipToCustomerBo.building = event.building;

      rq.shipToCustomerBo.transportData.routeDetails = event.routeDetails;
      rq.shipToCustomerBo.transportData.tmsLatitude = event.tmsLatitude;
      rq.shipToCustomerBo.transportData.tmsLongtitude = event.tmsLongtitude;
      CreateShiptoCustomerRs rs = await _customerService.createShiptoCustomer(applicationBloc.state.appSession, rq);

      SearchCustomerByOidRq searchCustomerByOidRq = new SearchCustomerByOidRq();
      searchCustomerByOidRq.customerOid = event.soldTo.customerOid;
      AppSession appSession = applicationBloc.state.appSession;
      SearchCustomerByOidRs searchCustomerByOidRs = await _customerService.searchCustomerByOid(appSession, searchCustomerByOidRq);

      yield CreateShipToCustomerSuccessState(searchCustomerByOidRs.customer);
    } catch (error, stackTrace) {
      yield ErrorCreateCustomerState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CreateCustomerState> mapCreateSoldToCustomer(CreateSoldToCustomerEvent event) async* {
    try {
      yield LoadingCreateCustomerState();
      AppSession appSession = applicationBloc.state.appSession;

      Customer customer = event.customer;

      CreateSoldToCustomerRq soldToRq = new CreateSoldToCustomerRq();
      soldToRq.soldToCustomerBo = new Customer();
      soldToRq.soldToCustomerBo.transportData = new TransportData();

      soldToRq.systemName = "SS";
      soldToRq.screenName = "Create CustomerSoldTo";
      soldToRq.companyCode = applicationBloc.state.appSession.userProfile.companyCode;
      soldToRq.fromStore = applicationBloc.state.appSession.userProfile.storeId;
      soldToRq.fromUser = applicationBloc.state.appSession.userProfile.empId;
      soldToRq.idCard = customer.taxId;

      soldToRq.soldToCustomerBo.type = customer.taxId.isEmpty ? '3' : '1';
      soldToRq.soldToCustomerBo.taxId = customer.taxId;
      soldToRq.soldToCustomerBo.title = customer.title ?? '';
      soldToRq.soldToCustomerBo.titleId = customer.titleId ?? '9999';
      soldToRq.soldToCustomerBo.firstName = customer.firstName;
      soldToRq.soldToCustomerBo.lastName = customer.lastName;
      soldToRq.soldToCustomerBo.email = customer.email;
      soldToRq.soldToCustomerBo.number = customer.number;
      soldToRq.soldToCustomerBo.unit = customer.unit;
      soldToRq.soldToCustomerBo.floor = customer.floor;
      soldToRq.soldToCustomerBo.village = customer.village;
      soldToRq.soldToCustomerBo.moo = customer.moo;
      soldToRq.soldToCustomerBo.soi = customer.soi;
      soldToRq.soldToCustomerBo.street = customer.street;
      soldToRq.soldToCustomerBo.placeId = customer.placeId;
      soldToRq.soldToCustomerBo.subDistrict = customer.subDistrict;
      soldToRq.soldToCustomerBo.district = customer.district;
      soldToRq.soldToCustomerBo.province = customer.province;
      soldToRq.soldToCustomerBo.zipCode = customer.zipCode;
      soldToRq.soldToCustomerBo.phoneNumber1 = customer.phoneNumber1;
      soldToRq.soldToCustomerBo.building = customer.building;

      soldToRq.soldToCustomerBo.transportData.routeDetails = customer.transportData.routeDetails;
      soldToRq.soldToCustomerBo.transportData.tmsLatitude = customer.transportData.tmsLatitude;
      soldToRq.soldToCustomerBo.transportData.tmsLongtitude = customer.transportData.tmsLongtitude;
      CreateSoldToCustomerRs soldToRs = await _customerService.createSoldToCustomer(applicationBloc.state.appSession, soldToRq);

      Customer soldToCustomer;
      SearchCustomerByOidRq searchCustomerByOidRq = SearchCustomerByOidRq();
      searchCustomerByOidRq.customerOid = soldToRs.customerOid;
      SearchCustomerByOidRs searchCustomerByOidRs = await _customerService.searchCustomerByOid(appSession, searchCustomerByOidRq);
      soldToCustomer = searchCustomerByOidRs.customer;

      yield CreateSoldToCustomerSuccessState(soldToCustomer);
    } catch (error, stackTrace) {
      yield ErrorCreateCustomerState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CreateCustomerState> mapBillToCreateCustomer(CreateBillToCustomerEvent event) async* {
    try {
      yield LoadingCreateCustomerState();

      CreateBillToCustomerRq rq = new CreateBillToCustomerRq();
      rq.billToCustomerBo = new Customer();
      rq.billToCustomerBo.transportData = new TransportData();

      rq.soldToCustomerOid = event.soldTo?.customerOid;
      rq.soldToSapId = event.soldTo?.sapId;
      rq.systemName = "SS";
      rq.screenName = "Create CustomerBillTo";
      rq.idCard = event.idCard;
      rq.companyCode = applicationBloc.state.appSession.userProfile.companyCode;
      rq.fromStore = applicationBloc.state.appSession.userProfile.storeId;
      rq.fromUser = applicationBloc.state.appSession.userProfile.empId;

      rq.billToCustomerBo.type = event.type;
      rq.billToCustomerBo.title = event.title;
      rq.billToCustomerBo.titleId = event.titleId;
      rq.billToCustomerBo.firstName = event.firstName;
      rq.billToCustomerBo.lastName = event.lastName;
      rq.billToCustomerBo.email = event.email;
      rq.billToCustomerBo.number = event.number;
      rq.billToCustomerBo.unit = event.unit;
      rq.billToCustomerBo.floor = event.floor;
      rq.billToCustomerBo.village = event.village;
      rq.billToCustomerBo.moo = event.moo;
      rq.billToCustomerBo.soi = event.soi;
      rq.billToCustomerBo.street = event.street;
      rq.billToCustomerBo.placeId = event.placeId;
      rq.billToCustomerBo.subDistrict = event.subDistrict;
      rq.billToCustomerBo.district = event.district;
      rq.billToCustomerBo.province = event.province;
      rq.billToCustomerBo.zipCode = event.zipcode;
      rq.billToCustomerBo.phoneNumber1 = event.phoneNumber1;
      rq.billToCustomerBo.building = event.building;
      rq.billToCustomerBo.taxId = event.idCard;
      rq.billToCustomerBo.branchId = event.branchId;
      rq.billToCustomerBo.branchType = event.branchType;
      rq.billToCustomerBo.branchDesc = event.branchDesc;

      rq.billToCustomerBo.transportData.routeDetails = event.routeDetails;
      rq.billToCustomerBo.transportData.tmsLatitude = event.tmsLatitude;
      rq.billToCustomerBo.transportData.tmsLongtitude = event.tmsLongtitude;
      CreateBillToCustomerRs rs = await _customerService.createBillToCustomer(applicationBloc.state.appSession, rq);

      SearchCustomerByOidRq searchCustomerByOidRq = SearchCustomerByOidRq();
      searchCustomerByOidRq.customerOid = event.soldTo.customerOid;
      SearchCustomerByOidRs searchCustomerByOidRs = await _customerService.searchCustomerByOid(applicationBloc.state.appSession, searchCustomerByOidRq);
      Customer billToCustomer = searchCustomerByOidRs.customer;

      yield CreateBillToCustomerSuccessState(billToCustomer);
    } catch (error, stackTrace) {
      yield ErrorCreateCustomerState(error: AppException(error, stackTrace: stackTrace));
    }
  }
}
