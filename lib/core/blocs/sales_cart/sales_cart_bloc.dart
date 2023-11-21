import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_coll_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_coll_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_so_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_so_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_customer_member_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_customer_member_rs.dart';
import 'package:flutter_store_catalog/core/models/user_profile.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_reserve.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/customer_information_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';

part 'sales_cart_event.dart';
part 'sales_cart_state.dart';

class SalesCartBloc extends Bloc<SalesCartEvent, SalesCartState> {
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();
  final ApplicationBloc applicationBloc;
  final ClmService _clmService = getIt<ClmService>();

  SalesCartBloc(this.applicationBloc);

  @override
  SalesCartState get initialState => SalesCartState();

  @override
  Stream<SalesCartState> mapEventToState(SalesCartEvent event) async* {
    if (event is SalesCartUpdateStateModelEvent) {
      yield* mapSalesCartUpdateStateModelEventToState(event);
    } else if (event is SalesCartResetEvent) {
      yield SalesCartState();
    } else if (event is SalesCartLoadEvent) {}
  }

  Stream<SalesCartState> mapSalesCartUpdateStateModelEventToState(SalesCartUpdateStateModelEvent event) async* {
    try {
      yield LoadingSalesCartState();

      AppSession appSession = applicationBloc.state.appSession;

      num salesCartOid = 0;

      // Case : Check Promotion
      if (event.salesCartDto.isCheckPrice && event.salesCartDto.isConfirmPayment) {
        yield SalesCartState(salesCartDto: event.salesCartDto);
        return;
      }

      // Case : Normal
      if (event.salesCartDto.salesCart.salesCartOid == null || event.salesCartDto.salesCart.salesCartOid == 0) {
        if (event.salesCartDto.salesCart.collectSalesOrder != null && event.salesCartDto.salesCart.collectSalesOrder.collectSalesOrderOid != 0) {
          GenerateSalesCartFromCollRq generateSalesCartFromCollRq = GenerateSalesCartFromCollRq();
          generateSalesCartFromCollRq.collSalesOrderOid = event.salesCartDto.salesCart.collectSalesOrder.collectSalesOrderOid;
          GenerateSalesCartFromCollRs generateSalesCartFromCollRs = await _saleOrderService.generateSalesCartFromColl(appSession, generateSalesCartFromCollRq);

          salesCartOid = generateSalesCartFromCollRs.salesCartOid;
        } else {
          GenerateSalesCartFromSoRq generateSalesCartFromSoRq = GenerateSalesCartFromSoRq();
          generateSalesCartFromSoRq.salesOrderOid = event.salesCartDto.salesCart.collectSalesOrder.collectSalesOrderOid;
          GenerateSalesCartFromSoRs generateSalesCartFromSoRs = await _saleOrderService.generateSalesCartFromSo(appSession, generateSalesCartFromSoRq);

          salesCartOid = generateSalesCartFromSoRs.salesCartOid;
        }
      } else {
        salesCartOid = event.salesCartDto.salesCart.salesCartOid;
      }

      GetSalesCartByOidRq getSalesCartByOidRq = GetSalesCartByOidRq();
      getSalesCartByOidRq.salesCartOid = salesCartOid;

      GetSalesCartByOidRs getSalesCartByOidRs = await _saleOrderService.getSalesCartByOid(appSession, getSalesCartByOidRq);
      SalesCartDto salesCartDto = SalesCartDto();
      salesCartDto.salesCart = getSalesCartByOidRs.salesCart;
      salesCartDto.flagMode = event.salesCartDto.flagMode;

      if (StringUtil.isNotEmpty(salesCartDto.getCustCardNo())) {
        try {
          GetCustomerMemberRq customerMemberRq = GetCustomerMemberRq();
          customerMemberRq.cardNo = salesCartDto.getCustCardNo();

          GetCustomerMemberRs rs = await _clmService.getCustomerMember(customerMemberRq);

          num totalMemberPoint = 0;
          if (rs != null && rs.cards != null && rs.cards.isNotEmpty) {
            rs.cards.where((element) => element.cardNo == salesCartDto.getCustCardNo()).forEach((e) {
              if (e.rewardPoints.isNotEmpty) {
                e.rewardPoints.forEach((r) {
                  totalMemberPoint = totalMemberPoint + r.point;
                });
              }
            });
          }
          // print('totalMemberPoint : $totalMemberPoint');
          salesCartDto.totalMemberPoint = totalMemberPoint;
        } catch (error, stackTrace) {}
      }

      yield SalesCartState(salesCartDto: salesCartDto, salesCartReserve: SalesCartReserve());
    } catch (error, stackTrace) {
      yield ErrorSalesCartState(error: AppException(error, stackTrace: stackTrace));
    }
  }
}
