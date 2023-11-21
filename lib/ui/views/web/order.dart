import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/app_timer/app_timer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/calculate_promotion/calculate_promotion_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/cancel_sales_cart/cancel_sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/create_sales/create_sales_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/delivery_inquiry_reserve/delivery_inquiry_reserve_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/hire_purchase/hire_purchase_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/inquiry_transaction/inquiry_transaction_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/order/order_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/save_sale_cart/save_sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_customer/search_customer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_customer_by_oid/search_customer_by_oid_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_ds_time_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data_item_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_reserve.dart';
import 'package:flutter_store_catalog/core/services/dotnet/customer_information_service.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/create_customer.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_checkbox.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_divider.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_table_calendar.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_toggle_tab.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_vertical_divider.dart';
import 'package:flutter_store_catalog/ui/widgets/dialog_customer.dart';
import 'package:flutter_store_catalog/ui/widgets/dialog_out_of_area.dart';
import 'package:flutter_store_catalog/ui/widgets/dialog_select_shipping_point_store.dart';
import 'package:flutter_store_catalog/ui/widgets/hire_purchase_bank_list.dart';
import 'package:flutter_store_catalog/ui/widgets/home_pro_care.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_solid_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/shipping_point_store_item.dart';
import 'package:flutter_store_catalog/ui/widgets/tender_list.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart' as GetArticleRs;
import 'order_dialog_customer_bill_to_panel.dart';

import 'checklist.dart';

part 'order_customer_panel.dart';

part 'order_inquiry_reserve_q_panel.dart';

part 'order_payment_panel.dart';

part 'order_summary_price.dart';

const VERTICAL_WIDTH = 1200;

class OrderPage extends StatefulWidget {
  final num salesCartOid;

  OrderPage({this.salesCartOid});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  bool isDiscount = false;

  AutoScrollController _scrollController;
  static const int _autoScrollTabIndex = 0;

  SalesCartDto _salesCartDto;

  OrderBloc orderBloc;
  DeliveryInquiryReserveBloc inquiryReserveBloc;
  CalculatePromotionBloc calProBloc;
  CreateSalesBloc createSalesBloc;
  HirePurchaseBloc hirePurchaseBloc;
  SaveSalesCartBloc saveSalesCartBloc;
  bool _isShowSameDayPanel = true;

  @override
  void initState() {
    _scrollController = AutoScrollController();

    SalesCartDto sc = SalesCartDto();
    sc.salesCart = SalesCart()..salesCartOid = widget.salesCartOid;
    BlocProvider.of<SalesCartBloc>(context).add(
      SalesCartUpdateStateModelEvent(sc),
    );
    super.initState();
  }

  @override
  dispose() {
    _scrollController.dispose();
    orderBloc.close();
    inquiryReserveBloc.close();
    calProBloc.close();
    createSalesBloc.close();
    hirePurchaseBloc.close();
    saveSalesCartBloc.close();
    super.dispose();
  }

  Future<void> _onServiceNotFound() async {
    var param = await DialogUtil.showCustomDialog(context, child: DialogOutOfArea());

    ShippingPointList shippingPointSelected;

    if (param == 'SEARCH_MORE') {
      // Case: Search more ship point
      shippingPointSelected = await DialogUtil.showCustomDialog(context, isScrollView: false, child: DialogSelectShippingPointStore());
    } else {
      // Case: Selected Store
      shippingPointSelected = param;
    }

    if (shippingPointSelected != null) {
      orderBloc.add(
        SelectShipToEvent(
          isCustomerReceive: true,
          shippingPointStore: shippingPointSelected,
        ),
      );
    }
  }

  void onTabBarDestinationSelected(int index) async {
    if (index == 0 && (await _validateBackStep('text.back_to_category'.tr(), 'warning.order_will_delete'.tr()) ?? true)) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false, arguments: {'isGoToCategoryTab': true});
    } else if (index == 1 && (await _validateBackStep('text.back_to_brand'.tr(), 'warning.order_will_delete'.tr()) ?? true)) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Brands, (route) => false);
    } else if (index == 2 && (await _validateBackStep('text.back_to_room'.tr(), 'warning.order_will_delete'.tr()) ?? true)) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Rooms, (route) => false);
    }
  }

  void onBack() async {
    if (await _validateBackStep('text.back_to_basket'.tr(), 'warning.order_will_delete'.tr()) ?? true) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void onHome() async {
    if (await _validateBackStep('text.back_to_home'.tr(), 'warning.order_will_delete'.tr()) ?? true) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false);
    }
  }

  void onChangeCustomer(num salesCartOid) async {
    final Customer customer = await DialogUtil.showCustomDialog(
      context,
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          child: DialogCustomer(partnerTypeId: CustomerPartnerType.SOLD_TO, phoneNo: null),
        ),
      ),
      backgroundColor: Colors.transparent,
      closeButtonColor: Colors.white,
      barrierDismissible: false,
      elevation: 0,
    );

    if (customer != null) {
      saveSalesCartBloc.add(
        SalesCartUpdateCustomerEvent(salesCartOid, customer),
      );
    }
  }

  Future<bool> _validateBackStep(String header, String text) async {
    if (orderBloc.state is CalculatePromotionCompleteState) {
      return await DialogUtil.showCustomDialog(context, child: PopupBackStep(header, text, CancelSalesType.SalesCart)) ?? false;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Mockup สำหรับ test คิวที่สร้างตะกร้ามาจาก SS อย่าพึ่งลบบบบบ
        BlocProvider<SearchCustomerBloc>(
          create: (context) => SearchCustomerBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<SearchCustomerByOidBloc>(
          create: (context) => SearchCustomerByOidBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => orderBloc = OrderBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context), BlocProvider.of<BasketBloc>(context)),
        ),
        BlocProvider<DeliveryInquiryReserveBloc>(
          create: (context) => inquiryReserveBloc = DeliveryInquiryReserveBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context)),
        ),
        BlocProvider<CalculatePromotionBloc>(
          create: (context) => calProBloc = CalculatePromotionBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context), BlocProvider.of<BasketBloc>(context)),
        ),
        BlocProvider<InquiryTransactionBloc>(
          create: (context) => InquiryTransactionBloc(),
        ),
        BlocProvider<CreateSalesBloc>(
          create: (context) => createSalesBloc = CreateSalesBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context), BlocProvider.of<InquiryTransactionBloc>(context)),
        ),
        BlocProvider<HirePurchaseBloc>(
          create: (context) => hirePurchaseBloc = HirePurchaseBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context), BlocProvider.of<CalculatePromotionBloc>(context)),
        ),
        BlocProvider<SaveSalesCartBloc>(
          create: (context) => saveSalesCartBloc = SaveSalesCartBloc(BlocProvider.of<BasketBloc>(context), BlocProvider.of<ApplicationBloc>(context)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SalesCartBloc, SalesCartState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingSalesCartState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is LoadingSalesCartState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ErrorSalesCartState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is SalesCartState) {
                _salesCartDto = state.salesCartDto;
                if (_salesCartDto.isNull) return;

                if (_salesCartDto.salesCart.salesOrders.isNotNE) {
                  _salesCartDto.isCustomerReceive = _salesCartDto.salesCart.salesOrders.first.salesOrderGroups?.first?.shippingPointId == Shippoint.CUSTOMER;
                  _salesCartDto.shipToCustomer = _salesCartDto.isCustomerReceive ? null : _salesCartDto.salesCart.customer.customerPartners.firstWhere((e) => e.partnerCustomer.customerOid == _salesCartDto.salesCart.salesOrders.first.salesOrderGroups?.first?.shipToCustomer?.customerOid)?.partnerCustomer;

                  state.salesCartReserve.soldto = _salesCartDto.salesCart.customer;
                  state.salesCartReserve.shipto = _salesCartDto.shipToCustomer;

                  orderBloc.add(AlreadyReservedQueueEvent());
                } else if (_salesCartDto.salesCart.customer.customerPartners.isNullOrEmpty) {
                  BlocProvider.of<SearchCustomerByOidBloc>(context).add(
                    SearchCustomerByOidEvent(customerOid: _salesCartDto.salesCart.customer.customerOid),
                  );
                } else {
                  orderBloc.add(ShowCustomerInfoToEvent());
                }
              }
            },
          ),
          BlocListener<SaveSalesCartBloc, SaveSalesCartState>(
            condition: (prevState, currentState) {
              if (prevState is SaveSalesCartLoadingState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is SaveSalesCartLoadingState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is SaveSalesCartErrorState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is SalesCartUpdateCustomerSuccessState) {
                SalesCartDto sc = SalesCartDto();
                sc.salesCart = SalesCart()..salesCartOid = state.salesCartOid;
                BlocProvider.of<SalesCartBloc>(context).add(
                  SalesCartUpdateStateModelEvent(sc),
                );
              }
            },
          ),
          //Mockup สำหรับ test คิวที่สร้างตะกร้ามาจาก SS อย่าพึ่งลบบบบบ
          BlocListener<SearchCustomerBloc, SearchCustomerState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingSearchCustomerByState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is LoadingSearchCustomerByState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ErrorSearchCustomerByState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is SuccessSearchByCustomerByState) {
                Customer customer = state.customers[0];
                BlocProvider.of<SalesCartBloc>(context).state.salesCartDto?.salesCart?.customer = customer;

                BlocProvider.of<SearchCustomerByOidBloc>(context).add(
                  SearchCustomerByOidEvent(customerOid: customer.customerOid),
                );
              }
            },
          ),
          BlocListener<SearchCustomerByOidBloc, SearchCustomerByOidState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingGetCustomerByOidState) {
                DialogUtil.hideLoadingDialog(context);
              }

              return true;
            },
            listener: (context, state) async {
              if (state is LoadingGetCustomerByOidState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ErrorGetCustomerByOidState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is SuccessGetCustomerByOidState) {
                List<CustomerPartners> custPartnerList = state.customerPartners?.map((element) {
                  return CustomerPartners()
                    ..partnerCustomer = element
                    ..partnerFunctionTypeId = element.partnerFunctionTypeId;
                })?.toList();

                BlocProvider.of<SalesCartBloc>(context).state.salesCartDto?.salesCart?.customer?.customerPartners = custPartnerList;
                _salesCartDto = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto;

                orderBloc.add(ShowCustomerInfoToEvent());
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) async {
              if (state is ErrorOrderState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is ShowCustomerInfoState) {
                if (state.backStepFlag == OrderStepBackFlag.CHANGE_CUSTOMER) {
                  onChangeCustomer(_salesCartDto.salesCart.salesCartOid);
                }
              } else if (state is ShipToSelectedState) {
                _salesCartDto.isCustomerReceive = state.isCustomerReceive;
                _salesCartDto.shipToCustomer = state.shipToCustomer;
                _salesCartDto.shippingPointStore = state.shippingPointStore;

                SalesCartReserve salesCartReserve = BlocProvider.of<SalesCartBloc>(context).state.salesCartReserve;
                salesCartReserve.isSameDay = false;
                salesCartReserve.isReserveSingleTime = false;
                inquiryReserveBloc.add(
                  InquiryQueueEvent(salesCartReserve: salesCartReserve, shippoint: _salesCartDto?.shippingPointStore?.shippingPointId),
                );
              } else if (state is QueueReservedState) {
                calProBloc.add(StartCalculatePromotionEvent(orderBloc.state.isValidateCanPayNow(_salesCartDto.salesCart.customer) ? CalPromotionCAAppId.SCAT_ONLINE : CalPromotionCAAppId.SCAT_POS));
              } else if (state is CalculatePromotionCompleteState) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _scrollController.scrollToIndex(
                    _autoScrollTabIndex,
                    preferPosition: AutoScrollPosition.begin,
                    duration: const Duration(milliseconds: 500),
                  );
                });
              }
            },
          ),
          BlocListener<CalculatePromotionBloc, CalculatePromotionState>(
            bloc: calProBloc,
            condition: (prevState, currentState) {
              if (prevState is LoadingCalculatePromotionState) {
                DialogUtil.hideLoadingDialog(context);
              }

              return true;
            },
            listener: (context, state) async {
              if (state is ErrorCalculatePromotionState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is LoadingCalculatePromotionState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is CalculatedState) {
                _salesCartDto.selectedTender = null;
                _salesCartDto.totalDiscount = state.totalDiscountAmt;
                _salesCartDto.netAmount = state.netTrnAmt;
                _salesCartDto.unpaid = state.unpaidAmt;

                orderBloc.add(CalPromotionEvent());
              } else if (state is SelectedTenderState) {
                _salesCartDto.totalDiscount = state.totalDiscountAmt;
                _salesCartDto.netAmount = state.netTrnAmt;
              }
            },
          ),
          BlocListener<DeliveryInquiryReserveBloc, DeliveryInquiryReserveState>(
            bloc: inquiryReserveBloc,
            condition: (prevState, currentState) {
              if (prevState is DeliveryInquiryReserveLoadingState) {
                DialogUtil.hideLoadingDialog(context);
              }

              return true;
            },
            listener: (context, state) async {
              if (state is DeliveryInquiryReserveLoadingState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is InquiryQueueErrorState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is InquiryQueueSelectDateErrorState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is ReserveQueueErrorState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is InquiryQueueSuccessState) {
                SalesCartReserve salesCartReserve = BlocProvider.of<SalesCartBloc>(context).state.salesCartReserve;
                if (salesCartReserve.isSameDay && !state.canReserveSameDay) {
                  return;
                }

                // bindDisplayQueueItem();
                _isShowSameDayPanel = state.isAllCanReserve && salesCartReserve.soMode != SOMode.CUST_RECEIVE && !state.isHaveFreeServiceQueue;
                orderBloc.add(InquiryQueueToEvent());
              } else if (state is CalculateDeliveryFeeSuccessState) {
                orderBloc.add(ChangeQueueDateToEvent());
              } else if (state is ReserveQueueSuccessState) {
                orderBloc.add(OrderReserveQueueEvent());
              } else if (state is ServiceAreaNotFoundState) {
                return _onServiceNotFound();
              }
            },
          ),
          BlocListener<CreateSalesBloc, CreateSalesState>(
            bloc: createSalesBloc,
            condition: (prevState, currentState) {
              if (prevState is LoadingCreateSalesState) {
                DialogUtil.hideLoadingDialog(context);
              }

              return true;
            },
            listener: (context, state) async {
              if (state is ErrorCreateSalesState) {
                await DialogUtil.showErrorDialog(context, state.error);
              } else if (state is LoadingCreateSalesState) {
                DialogUtil.showLoadingDialog(context);
              }
            },
          ),
          BlocListener<HirePurchaseBloc, HirePurchaseState>(
              bloc: hirePurchaseBloc,
              condition: (prevState, currentState) {
                if (prevState is LoadingHirePurchaseState) {
                  DialogUtil.hideLoadingDialog(context);
                }
                return true;
              },
              listener: (context, state) async {
                if (state is LoadingHirePurchaseState) {
                  DialogUtil.showLoadingDialog(context);
                } else if (state is ErrorHirePurchaseState) {
                  await DialogUtil.showErrorDialog(context, state.error);
                }
              }),
        ],
        child: BlocBuilder<OrderBloc, OrderState>(
          bloc: orderBloc,
          builder: (context, state) {
            if (state is InitialOrderState || BlocProvider.of<SalesCartBloc>(context).state.salesCartDto.isNull) {
              return Container();
            } else {
              return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                Widget content = Container();
                if (constraints.maxWidth < VERTICAL_WIDTH || constraints.maxHeight > constraints.maxWidth) {
                  content = _buildPortrait(context);
                } else {
                  content = _buildLandscape(context);
                }

                return WillPopScope(
                  onWillPop: () {
                    onBack();
                    return;
                  },
                  child: CommonLayout(
                    isShowBack: true,
                    isShowBasket: false,
                    isShowSearch: false,
                    onDestinationSelected: onTabBarDestinationSelected,
                    onHome: onHome,
                    onBack: onBack,
                    body: content,
                  ),
                );
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildCustomerPanel(context),
                  ),
                  if (state is InquiryQueueCompleteState || state is QueueReservedState || state is CalculatePromotionCompleteState) CustomVericalDivider(),
                  if (state is InquiryQueueCompleteState || state is QueueReservedState || state is CalculatePromotionCompleteState)
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildOrderPanel(context),
                          ),
                          _buildSummaryPricePanel(context),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          CustomVericalDivider(),
          Expanded(
            flex: state is ShowCustomerInfoState || state is ShipToSelectedState ? 3 : 1,
            child: state is CalculatePromotionCompleteState ? _buildPaymentPanel(context) : Container(),
          ),
        ],
      );
    });
  }

  Widget _buildPortrait(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      return Scaffold(
        body: ListView(
          controller: _scrollController,
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  _buildCustomerPanel(context, isPortrait: true),
                  CustomDivider(),
                  if (state is InquiryQueueCompleteState || state is QueueReservedState || state is CalculatePromotionCompleteState)
                    Column(
                      children: [
                        _buildOrderPanel(context, isPortrait: true),
                        SizedBox(height: 30.0),
                        AutoScrollTag(
                          key: ValueKey(_autoScrollTabIndex),
                          controller: _scrollController,
                          index: _autoScrollTabIndex,
                          child: StickyHeader(
                            header: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  _buildSummaryPricePanel(context),
                                  CustomDivider(),
                                ],
                              ),
                            ),
                            content: state is CalculatePromotionCompleteState ? _buildPaymentPanel(context, isPortrait: true) : Container(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: CustomBackToTopButton(scrollController: _scrollController),
      );
    });
  }

  Widget _buildHeader(BuildContext context, String panelNo, String panelName) {
    return Row(
      children: [
        Material(
          child: Ink(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: colorDark,
            ),
            child: Container(
              width: 25,
              height: 25,
              child: Center(
                child: Text(
                  panelNo,
                  style: Theme.of(context).textTheme.normal.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              panelName,
              style: Theme.of(context).textTheme.larger.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerPanel(BuildContext context, {bool isPortrait = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildHeader(context, '1', 'text.customer_info'.tr()),
              ),
              Material(
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: IconButton(
                    icon: const Icon(NovaSolidIcon.user_group_refresh),
                    color: Colors.white,
                    onPressed: () async {
                      bool validateBack = await _validateBackStep('common.dialog_title_warning'.tr(), '${'warning.edit_delivery_date.first'.tr()}\n${'warning.edit_delivery_date.second'.tr()}');
                      if (validateBack != null) {
                        if (validateBack) orderBloc.add(BackStepToCustomerPanel(backStepFlag: OrderStepBackFlag.CHANGE_CUSTOMER));
                      } else {
                        onChangeCustomer(_salesCartDto.salesCart.salesCartOid);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          CustomerPanel(
            salesCartDto: _salesCartDto,
            calProBloc: calProBloc,
            orderBloc: orderBloc,
            isPortrait: isPortrait,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderPanel(BuildContext context, {bool isPortrait = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 15.0, bottom: 5.0),
      child: Column(
        children: [
          _buildHeader(context, '2', 'text.delivery_date'.tr()),
          SizedBox(height: 10),
          InquiryAndReserveQueuePanel(
            salesCartDto: _salesCartDto,
            orderBloc: orderBloc,
            inquiryReserveBloc: inquiryReserveBloc,
            isEnableSameDayPanel: _isShowSameDayPanel,
            isPortrait: isPortrait,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPanel(BuildContext context, {bool isPortrait = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 15.0, bottom: 15.0),
      child: Column(
        children: [
          _buildHeader(context, '3', 'text.payment_method'.tr()),
          SizedBox(height: 10),
          PaymentPanel(
            salesCartDto: _salesCartDto,
            orderBloc: orderBloc,
            calProBloc: calProBloc,
            createSalesBloc: createSalesBloc,
            hirePurchaseBloc: hirePurchaseBloc,
            isPortrait: isPortrait,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPricePanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 20.0, bottom: 15.0),
      child: SummaryPrice(
        salesCartDto: _salesCartDto,
        orderBloc: orderBloc,
        inquiryReserveBloc: inquiryReserveBloc,
        calProBloc: calProBloc,
        autoScrollTabIndex: _autoScrollTabIndex,
        scrollController: _scrollController,
      ),
    );
  }
}

class PopupBackStep extends StatefulWidget {
  final String title;
  final String text;
  final CancelSalesType cancelSalesType;

  PopupBackStep(this.title, this.text, this.cancelSalesType);

  @override
  _PopupBackStepState createState() => _PopupBackStepState();
}

class _PopupBackStepState extends State<PopupBackStep> {
  CancelSalesCartBloc _cancelSalesCartBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    _cancelSalesCartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CancelSalesCartBloc, CancelSalesCartState>(
      bloc: _cancelSalesCartBloc = CancelSalesCartBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context)),
      listenWhen: (prevState, currentState) {
        if (prevState is LoadingCancelSalesCartState) {
          DialogUtil.hideLoadingDialog(context);
        }
        return true;
      },
      listener: (context, state) async {
        if (state is ErrorCancelSalesCartState) {
          DialogUtil.showErrorDialog(context, state.error);
        } else if (state is LoadingCancelSalesCartState) {
          DialogUtil.showLoadingDialog(context);
        } else if (state is SuccessCancelSalesCartState) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Container(
          width: 450,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.title,
                    style: Theme.of(context).textTheme.larger.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                SizedBox(height: 20),
                Text(widget.text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.normal),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary: colorBlue7,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            'text.back'.tr(),
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary: colorAccent,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            switch (widget.cancelSalesType) {
                              case CancelSalesType.SalesCart:
                                _cancelSalesCartBloc.add(CancelSalesCartItemEvent());
                                break;
                              case CancelSalesType.SalesOrder:
                                _cancelSalesCartBloc.add(CancelSalesOrderEvent());
                                break;
                            }
                          },
                          child: Text(
                            'common.dialog_button_ok'.tr(),
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
