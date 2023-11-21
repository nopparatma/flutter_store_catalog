import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data_item_dto.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';

class SalesCartDto {
  SalesCart salesCart;
  bool isLoaded;
  bool isSelected;
  CollectSalesOrder loadedCollectSalesOrder;
  SalesOrder loadedSalesOrder;
  SalesCart loadedSalesCart;
  String soMode;
  bool isReserveSingleTime;
  String flagMode; // flagMode from 'PopupMenuButton' (Edit, Delete, Payment, Merge) By tabOrder

  bool isCheckPrice;
  bool isConfirmPayment;
  String calculatePromotionCAType;
  PromotionRedemption promotionRedemption;

  bool isCustomerReceive;
  Customer shipToCustomer;
  Customer billToCustomer;

  List<QueueDataItemDto> displayQueueItemList;
  List<SuggestTender> creditTenderList;
  List<SuggestTender> qrTenderList;
  List<SuggestTender> otherTenderList;
  SuggestTender selectedTender;
  MstMbrCardGroupDet selectedDiscountCard;

  List<HirePurchaseDto> hirePurchaseList;
  List<SalesItem> populateSalesItem;
  List<SalesItem> populateSalesItemForPay;
  Map<String, HirePurchasePromotion> selectPromotionMap;


  num totalPrice;
  num totalDeliveryFee;
  num totalDiscount;
  num unpaid;
  num netAmount;
  num totalMemberPoint;

  //Lack Free Goods Parameter
  SelectLackFreeGoods exceptLackFreeGoods;
  //key = SalesOrderItemOid
  Map<num, List<SalesCartItem>> lackFreeGoodsSalesCartItemMap;

  ShippingPointList shippingPointStore;

  SalesCartDto({
    this.salesCart,
    this.isLoaded,
    this.isSelected,
    this.loadedCollectSalesOrder,
    this.loadedSalesOrder,
    this.loadedSalesCart,
    this.soMode,
    this.isReserveSingleTime,
    this.flagMode,
    this.isCheckPrice,
    this.isConfirmPayment,
    this.promotionRedemption,
    this.isCustomerReceive = false,
    this.billToCustomer,
    this.shipToCustomer,
    this.displayQueueItemList,
    this.creditTenderList,
    this.qrTenderList,
    this.otherTenderList,
    this.selectedTender,
    this.totalPrice = 0,
    this.totalDeliveryFee = 0,
    this.totalDiscount = 0,
    this.unpaid,
    this.netAmount = 0,
    this.totalMemberPoint = 0,
  }) {
    isCheckPrice = false;
    isConfirmPayment = false;
  }

  int getBadgeItemLength() {
    return salesCart != null && salesCart.salesCartItems != null ? salesCart.salesCartItems.where((e) => e.qtyRemain > 0).length : 0;
  }

  String getCustFullName() {
    if (salesCart != null && salesCart.customer != null) {
      return '${salesCart.customer.firstName} ${salesCart.customer.lastName ?? ''}';
    } else if (salesCart != null && salesCart.firstName != null) {
      return '${salesCart.firstName} ${salesCart.lastName ?? ''}';
    }
    return '';
  }

  String getBillToFullNameWithTitle() {
    if (billToCustomer != null) {
      if (billToCustomer.title.isNullEmptyOrWhitespace) {
        return '${billToCustomer.firstName} ${billToCustomer.lastName ?? ''}';
      }

      return '${billToCustomer.title} ${billToCustomer.firstName} ${billToCustomer.lastName ?? ''}';
    }
    return '';
  }

  String getBillToAddress() {
    if (billToCustomer != null) {
      return StringUtil.getAddress(
        billToCustomer.village,
        billToCustomer.floor,
        billToCustomer.unit,
        billToCustomer.soi,
        billToCustomer.moo,
        billToCustomer.number,
        billToCustomer.street,
        billToCustomer.subDistrict,
        billToCustomer.district,
        billToCustomer.province,
        billToCustomer.zipCode,
      );
    }
    return '';
  }

  String getCustTelNo() {
    if (salesCart != null && salesCart.customer != null) {
      return '${salesCart.customer.phoneNumber1}';
    } else if (salesCart != null && salesCart.firstName != null) {
      return '${salesCart.telephoneNo}';
    }
    return '';
  }

  String getCustCardNo() {
    if (salesCart?.customer?.cardNumber != null) {
      return '${salesCart.customer.cardNumber}';
    }
    return '';
  }
}
