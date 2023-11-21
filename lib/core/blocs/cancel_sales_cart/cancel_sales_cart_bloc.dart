import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_coll_so_sales_cart_payment_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancelq_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/save_sales_cart_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/save_sales_cart_rs.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:meta/meta.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_sales_cart_rq.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';

part 'cancel_sales_cart_event.dart';
part 'cancel_sales_cart_state.dart';

class CancelSalesCartBloc extends Bloc<CancelSalesCartEvent, CancelSalesCartState> {
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();
  final ApplicationBloc applicationBloc;
  final SalesCartBloc salesCartBloc;

  CancelSalesCartBloc(this.applicationBloc, this.salesCartBloc);

  @override
  CancelSalesCartState get initialState => InitialCancelSalesCartState();

  @override
  Stream<CancelSalesCartState> mapEventToState(CancelSalesCartEvent event) async* {
    if (event is CancelSalesCartItemEvent) {
      yield* mapCancelSalesCartItemToState(event);
    } else if (event is CancelSalesOrderEvent) {
      yield* mapCancelSalesOrderToState(event);
    }
  }

  Stream<CancelSalesCartState> mapCancelSalesCartItemToState(CancelSalesCartItemEvent event) async* {
    try {
      yield LoadingCancelSalesCartState();

      AppSession appSession = applicationBloc.state.appSession;

      CancelSalesCartRq cancelSalesCartRq = CancelSalesCartRq();
      cancelSalesCartRq.lastUpdUser = appSession.userProfile.empId;
      cancelSalesCartRq.salesCartOid = salesCartBloc.state.salesCartDto.salesCart.salesCartOid;

      await _saleOrderService.cancelSalesCart(appSession, cancelSalesCartRq);

      SalesCart tmpSalesCart = salesCartBloc.state.salesCartDto.salesCart;
      tmpSalesCart.salesCartOid = 0;
      tmpSalesCart.createDateTime = null;
      tmpSalesCart.lastUpdDttm = null;
      tmpSalesCart.createUser = appSession.userProfile.empId;
      tmpSalesCart.lastUpdateUser = appSession.userProfile.empId;
      tmpSalesCart.salesOrders = null;
      tmpSalesCart.collectSalesOrder = null;
      tmpSalesCart.simulatePaymentBo = null;
      tmpSalesCart.salesCartItems.removeWhere((e) => e.isDeliveryFee ?? false);
      tmpSalesCart.salesCartItems.forEach((e) {
        e.salesCartItemOid = 0;
        e.salesOrderGroupOid = null;
        e.salesOrderItemOid = null;
        e.salesOrderOid = null;
        e.refSalesCartItemOid = null;
        e.refMainItemIndex = e.refSalesCartItemOid != null && e.refSalesCartItemOid != 0 ? tmpSalesCart.salesCartItems.indexWhere((s) => s.salesCartItemOid == e.refSalesCartItemOid) : null;
        e.qtyRemain = e.qty;
      });

      SaveSalesCartRq saveSalesCartRq = new SaveSalesCartRq();
      saveSalesCartRq.salesCartBo = tmpSalesCart;
      SaveSalesCartRs saveSalesCartRs = await _saleOrderService.saveSalesCart(appSession, saveSalesCartRq);

      GetSalesCartByOidRq getSalesCartByOidRq = GetSalesCartByOidRq();
      getSalesCartByOidRq.salesCartOid = saveSalesCartRs.salesCartOid;

      GetSalesCartByOidRs getSalesCartByOidRs = await _saleOrderService.getSalesCartByOid(applicationBloc.state.appSession, getSalesCartByOidRq);

      salesCartBloc.state.salesCartDto.salesCart = getSalesCartByOidRs.salesCart;

      yield SuccessCancelSalesCartState();

    } catch (error, stackTrace) {
      yield ErrorCancelSalesCartState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CancelSalesCartState> mapCancelSalesOrderToState(CancelSalesOrderEvent event) async* {
    try {
      yield LoadingCancelSalesCartState();

      AppSession appSession = applicationBloc.state.appSession;
      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;

      if(salesCartDto.salesCart.collectSalesOrder?.collectSalesOrderOid?.isNotNE ?? false){
        CancelCollSOSalesCartPaymentRq cancelCollSOSalesCartPaymentRq = CancelCollSOSalesCartPaymentRq();
        cancelCollSOSalesCartPaymentRq.collectSalesOrderOid = salesCartDto.salesCart.collectSalesOrder?.collectSalesOrderOid;
        cancelCollSOSalesCartPaymentRq.lastUpdateUser = appSession.userProfile.empId;
        cancelCollSOSalesCartPaymentRq.salesCartOid = salesCartDto.salesCart?.salesCartOid;

        _saleOrderService.cancelCollSOSalesCartPayment(appSession, cancelCollSOSalesCartPaymentRq);

      }

      for(SalesOrder salesOrder in salesCartDto.salesCart.salesOrders) {
        for (SalesOrderGroup salesOrderGroup in salesOrder.salesOrderGroups){

          SalesOrder tmpSalesOrder = SalesOrder.fromJson(salesOrder.toJson());
          tmpSalesOrder.salesOrderGroups = [salesOrderGroup];

          CancelQRq rq = new CancelQRq();
          rq.salesCartOid = salesCartDto.salesCart.salesCartOid;
          rq.salesOrderBo = tmpSalesOrder;
          rq.stateQ = MasterTabDelivery.QDELIVERY;
          rq.updateBy = appSession.userProfile.empId;
          await _saleOrderService.cancelQ(applicationBloc.state.appSession, rq);
        }
      }

      GetSalesCartByOidRq getSalesCartByOidRq = GetSalesCartByOidRq();
      getSalesCartByOidRq.salesCartOid = salesCartBloc.state.salesCartDto.salesCart.salesCartOid;

      // await new Future.delayed(const Duration(seconds: 5));

      GetSalesCartByOidRs getSalesCartByOidRs = await _saleOrderService.getSalesCartByOid(applicationBloc.state.appSession, getSalesCartByOidRq);

      salesCartBloc.state.salesCartDto.salesCart = getSalesCartByOidRs.salesCart;

      yield SuccessCancelSalesCartState();

    } catch (error, stackTrace) {
      yield ErrorCancelSalesCartState(error: AppException(error, stackTrace: stackTrace));
    }
  }
}
