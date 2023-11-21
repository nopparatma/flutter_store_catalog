import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_coll_so_sales_cart_payment_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_coll_so_sales_cart_payment_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_sales_cart_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_sales_cart_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancelq_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancelq_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_collect_sales_order_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_collect_sales_order_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_sales_order_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_sales_order_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_coll_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_coll_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_so_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/generate_sales_cart_from_so_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_available_queue_times_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_available_queue_times_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_fee_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_fee_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sell_channel_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sell_channel_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_article_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_article_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_info_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_info_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_top_worker_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_top_worker_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/inquiry_stock_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/inquiry_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/reserve_queue_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/reserve_queue_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sms_create_sales_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sms_create_sales_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/save_sales_cart_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/save_sales_cart_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/base_backoffice_webapi_service.dart';

class SaleOrderService extends BaseBackOfficeWebApiService {
  static const String controllerName = 'so';

  Future<GetArticleForSalesCartItemRs> getArticleForSalesCartItem(AppSession appSession, GetArticleForSalesCartItemRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getArticleForSalesCartItem',
      rq.toJson(),
      (data) => GetArticleForSalesCartItemRs.fromJson(data),
    );
  }

  Future<GetSalesCartByOidRs> getSalesCartByOid(AppSession appSession, GetSalesCartByOidRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getSalesCartByOid',
      rq.toJson(),
      (data) => GetSalesCartByOidRs.fromJson(data),
    );
  }

  Future<GetAvailableQueueTimesRs> getAvailableQueueTimes(AppSession appSession, GetAvailableQueueTimesRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getAvailableQueueTimes',
      rq.toJson(),
      (data) => GetAvailableQueueTimesRs.fromJson(data),
    );
  }

  Future<GetStoreInfoRs> getStoreInfo(AppSession appSession, GetStoreInfoRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getStoreInfo',
      rq.toJson(),
      (data) => GetStoreInfoRs.fromJson(data),
    );
  }

  Future<GenerateSalesCartFromCollRs> generateSalesCartFromColl(AppSession appSession, GenerateSalesCartFromCollRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/generateSalesCartFromColl',
      rq.toJson(),
      (data) => GenerateSalesCartFromCollRs.fromJson(data),
    );
  }

  Future<GenerateSalesCartFromSoRs> generateSalesCartFromSo(AppSession appSession, GenerateSalesCartFromSoRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/generateSalesCartFromSo',
      rq.toJson(),
      (data) => GenerateSalesCartFromSoRs.fromJson(data),
    );
  }

  Future<InquiryStockRs> inquiryStock(AppSession appSession, InquiryStockRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/inquiryStock',
      rq.toJson(),
      (data) => InquiryStockRs.fromJson(data),
    );
  }

  Future<UpdateSalesCartCustomerRs> updateSalesCartCustomer(AppSession appSession, UpdateSalesCartCustomerRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/updateSalesCartCustomer',
      rq.toJson(),
      (data) => UpdateSalesCartCustomerRs.fromJson(data),
    );
  }

  Future<GetSpecialConditionItemRs> getSpecialConditionItem(AppSession appSession, GetSpecialConditionItemRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getSpecialConditionItem',
      rq.toJson(),
      (data) => GetSpecialConditionItemRs.fromJson(data),
    );
  }

  Future<GetDeliveryFeeRs> getDeliveryFee(AppSession appSession, GetDeliveryFeeRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getDeliveryFee',
      rq.toJson(),
      (data) => GetDeliveryFeeRs.fromJson(data),
    );
  }

  Future<CreateSalesOrderRs> createSalesOrder(AppSession appSession, CreateSalesOrderRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/createSalesOrder',
      rq.toJson(),
      (data) => CreateSalesOrderRs.fromJson(data),
    );
  }

  Future<GetTopWorkerRs> getTopWorker(AppSession appSession, GetTopWorkerRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getTopWorker',
      rq.toJson(),
      (data) => GetTopWorkerRs.fromJson(data),
    );
  }

  Future<ReserveQueueRs> reserveQueueForFreeGoods(AppSession appSession, ReserveQueueRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/reserveQueueForFreeGoods',
      rq.toJson(),
      (data) => ReserveQueueRs.fromJson(data),
    );
  }

  Future<CancelCollSOSalesCartPaymentRs> cancelCollSOSalesCartPayment(AppSession appSession, CancelCollSOSalesCartPaymentRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/cancelCollSOSalesCartPayment',
      rq.toJson(),
      (data) => CancelCollSOSalesCartPaymentRs.fromJson(data),
    );
  }

  Future<CreateCollectSalesOrderRs> createCollectSalesOrder(AppSession appSession, CreateCollectSalesOrderRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/createCollectSalesOrder',
      rq.toJson(),
      (data) => CreateCollectSalesOrderRs.fromJson(data),
    );
  }

  Future<SmsCreateSalesRs> smsCreateSales(AppSession appSession, SmsCreateSalesRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/smsCreateSales',
      rq.toJson(),
      (data) => SmsCreateSalesRs.fromJson(data),
    );
  }

  Future<GetSellChannelRs> getSellChannel(AppSession appSession, GetSellChannelRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getSellChannel',
      rq.toJson(),
          (data) => GetSellChannelRs.fromJson(data),
    );
  }

  Future<SaveSalesCartRs> saveSalesCart(AppSession appSession, SaveSalesCartRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/saveSalesCart',
      rq.toJson(),
      (data) => SaveSalesCartRs.fromJson(data),
    );
  }

  Future<GetShippingPointStoreRs> getShippingPointStore(AppSession appSession, GetShippingPointStoreRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getShippingPointStore',
      rq.toJson(),
      (data) => GetShippingPointStoreRs.fromJson(data),
    );
  }

  Future<CancelSalesCartRs> cancelSalesCart(AppSession appSession, CancelSalesCartRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/cancelSalesCart',
      rq.toJson(),
          (data) => CancelSalesCartRs.fromJson(data),
    );
  }

  Future<CancelQRs> cancelQ(AppSession appSession, CancelQRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/cancelQ',
      rq.toJson(),
          (data) => CancelQRs.fromJson(data),
    );
  }

  Future<GetSpecialConditionArticleRs> getSpecialConditionArticle(AppSession appSession, GetSpecialConditionArticleRq rq) async {
    return await post(
      '${appSession.ssApiServerUrl}/$bkoffcContextApi/$controllerName/getSpecialConditionArticle',
      rq.toJson(),
          (data) => GetSpecialConditionArticleRs.fromJson(data),
    );
  }
}
