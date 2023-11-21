import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/app_timer/app_timer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/checklist_information/checklist_information_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/consent_policy/consent_policy_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/save_sale_cart/save_sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_customer/search_customer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_customer_by_oid/search_customer_by_oid_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/models/view/checklist_data.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/create_customer.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_close_dialog_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_html.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_number_pad.dart';
import 'package:flutter_store_catalog/ui/widgets/dialog_customer.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_solid_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/quantity_control.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/transaction_salescart_checklist_rq.dart' as TransactionSalesCartRq;

import 'checklist.dart';

class BasketPage extends StatefulWidget {
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  static final double headerSize = AppBar().preferredSize.height;
  static double pageWidth = 1920;

  SaveSalesCartBloc saveSalesCartBloc;

  ScrollController basketItemScrollController;

  @override
  void initState() {
    super.initState();

    basketItemScrollController = ScrollController();
    if (BlocProvider.of<ConsentPolicyBloc>(context).state is! SuccessConsentPolicyState) {
      BlocProvider.of<ConsentPolicyBloc>(context).add(LoadConsentPolicyEvemt());
    }
  }

  @override
  dispose() {
    saveSalesCartBloc.close();
    DialogUtil.hideLoadingDialog(context);
    super.dispose();
  }

  Future<void> onRemoveItem(BasketItem item) async {
    String artName = LanguageUtil.isTh(context) ? item.article.articleNameTH : item.article.articleNameEN;

    bool result = await DialogUtil.showConfirmDialog(context, title: 'text.confirm_remove_item'.tr(), message: artName);
    if (result ?? false) {
      BlocProvider.of<BasketBloc>(context).add(
        BasketRemoveItemEvent(item),
      );
    }
  }

  Future<void> onEditCheckList(BasketItem item) async {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

    CheckListData checkListData = await DialogUtil.showCustomDialog(
      context,
      child: Container(
        width: 800,
        height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
        child: CheckListPanel(
          articleDetail: item.article,
          modeEdit: true,
          checkListData: item.checkListData,
        ),
      ),
    );

    if (checkListData == null) return null;

    if (item.checkListData.residenceSelected != checkListData.residenceSelected || item.checkListData.patternTypeSelected != checkListData.patternTypeSelected|| item.checkListData.patternAreaSelected != checkListData.patternAreaSelected) {
      BlocProvider.of<BasketBloc>(context).add(
        BasketUpdateItemCheckListEvent(item, checkListData),
      );
    }
  }

  void onPay() async {
    SalesCart salesCart = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto?.salesCart;
    Customer customer = salesCart?.customer;

    if (customer == null) {
      customer = await DialogUtil.showCustomDialog(
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
    }

    if (customer != null) {
      saveSalesCartBloc.add(SaveSalesCartWithCustomerEvent(customer, salesCart: salesCart));
    }
  }

  void onPayAtCashier() async {
    SalesCart salesCart = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto?.salesCart;
    String phoneNo = salesCart?.customer?.phoneNumber1;
    if (phoneNo == null) {
      phoneNo = await DialogUtil.showCustomDialog(
        context,
        isShowCloseButton: true,
        child: CashierPayment(),
        backgroundColor: Colors.transparent,
        closeButtonColor: Colors.white,
        barrierDismissible: false,
        elevation: 0,
      );
    }
    if (phoneNo != null) {
      saveSalesCartBloc.add(SaveSalesCartWithPhoneNoEvent(phoneNo, salesCart: salesCart));
    }
  }

  onContinueWithMySelf(num salesCartOid, String phoneNo) async {
    SalesCart salesCart = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto?.salesCart;
    Customer customer = salesCart?.customer;

    if (customer == null) {
      // Navigator.pop(context);
      customer = await DialogUtil.showCustomDialog(
        context,
        child: Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          // make sure that the overlay content is not cut off
          child: SafeArea(
            child: DialogCustomer(partnerTypeId: CustomerPartnerType.SOLD_TO, phoneNo: phoneNo),
          ),
        ),
        backgroundColor: Colors.transparent,
        closeButtonColor: Colors.white,
        barrierDismissible: false,
        elevation: 0,
      );
    }

    if (customer != null) {
      saveSalesCartBloc.add(SalesCartUpdateCustomerEvent(salesCartOid, customer));
    }
  }

  Future<void> onTapClearAll() async {
    bool result = await DialogUtil.showConfirmDialog(
      context,
      title: 'text.confirm_remove_item'.tr(),
      message: 'text.confirm_remove_all_product'.tr(),
    );

    if (result ?? false) {
      BlocProvider.of<BasketBloc>(context).add(ResetBasketEvent());
      BlocProvider.of<SalesCartBloc>(context).add(SalesCartResetEvent());
      BlocProvider.of<AppTimerBloc>(context).add(AppTimerReset());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveSalesCartBloc>(
          create: (context) => saveSalesCartBloc = SaveSalesCartBloc(BlocProvider.of<BasketBloc>(context), BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<SearchCustomerBloc>(
          create: (context) => SearchCustomerBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<SearchCustomerByOidBloc>(
          create: (context) => SearchCustomerByOidBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
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
              } else if (state is SaveSalesWithCustomerSuccessState) {
                if (state.isScatException ?? false) {
                  await DialogUtil.showCustomDialog(
                    context,
                    isShowCloseButton: false,
                    backgroundColor: Colors.white,
                    child: Container(
                      width: 320,
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'common.dialog_title_warning'.tr(),
                            style: Theme.of(context).textTheme.larger.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorRed1,
                                ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'text.please_contact_staff_scat_exception'.tr(namedArgs: {"newLine": "\n"}),
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: colorDark,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                                      Navigator.pop(context);
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  BlocProvider.of<BasketBloc>(context).add(ResetBasketEvent());
                  BlocProvider.of<SalesCartBloc>(context).add(SalesCartResetEvent());
                  BlocProvider.of<AppTimerBloc>(context).add(AppTimerReset());
                  Navigator.pushReplacementNamed(context, WebRoutePaths.Home);
                  return;
                }
                Navigator.of(context).pushNamed(WebRoutePaths.Order, arguments: {'salesCartOid': state.salesCartOid});
              } else if (state is SaveSalesWithPhoneSuccessState) {
                final bool isNextStep = await DialogUtil.showCustomDialog(
                  context,
                  backgroundColor: Colors.white,
                  child: buildCompleteCashier(state.phoneNo),
                );

                if (isNextStep ?? false) {
                  onContinueWithMySelf(state.salesCartOid, state.phoneNo);
                  return;
                }
                BlocProvider.of<BasketBloc>(context).add(ResetBasketEvent());
                BlocProvider.of<SalesCartBloc>(context).add(SalesCartResetEvent());
                BlocProvider.of<AppTimerBloc>(context).add(AppTimerReset());
                Navigator.pushReplacementNamed(context, WebRoutePaths.Home);
              } else if (state is SalesCartUpdateCustomerSuccessState) {
                Navigator.of(context).pushNamed(WebRoutePaths.Order, arguments: {'salesCartOid': state.salesCartOid});
              }
            },
          ),
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
                // BlocProvider.of<SearchCustomerByOidBloc>(context).add(
                //   SearchCustomerByOidEvent(customerOid: customer.customerOid),
                // );
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
                // Navigator.pushNamed(context, WebRoutePaths.Order);
              }
            },
          ),
          BlocListener<BasketBloc, BasketState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingBasketState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is LoadingBasketState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ErrorBasketState) {
                DialogUtil.showErrorDialog(context, state.error);
              }
            },
          ),
          BlocListener<SalesCartBloc, SalesCartState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingSalesCartState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) {
              if (state is LoadingSalesCartState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ErrorSalesCartState) {
                DialogUtil.showErrorDialog(context, state.error);
              }
            },
          ),
        ],
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          pageWidth = constraints.maxWidth;

          return Scaffold(
            body: Column(
              children: [
                _buildHeader(context),
                _buildContent(context),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Ink(
          height: 8,
          color: colorDark,
        ),
        Container(
          height: headerSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorOrangeGradient1, colorOrangeGradient2],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: 20.0),
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      padding: EdgeInsets.all(8),
                      //height: headerSize * 0.75,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorDark,
                      ),
                      child: Container(
                        child: Icon(
                          NovaSolidIcon.shopping_cart_2,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text('text.cart'.tr(),
                      style: Theme.of(context).textTheme.larger.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  SizedBox(width: 20.0),
                  buildButtonClearAll(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomCloseDialogButton(
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButtonClearAll() {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        if (state is BasketState && state.isFoundArticle()) {
          return InkWell(
            child: Text(
              'text.clear_all'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            onTap: () {
              onTapClearAll();
            },
          );
        }

        return Container();
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      flex: 11,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasket(context),
          _buildSummary(context),
        ],
      ),
    );
  }

  Widget _buildBasket(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5.0,
              offset: Offset(0.0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 0),
          child: BlocBuilder<BasketBloc, BasketState>(
              condition: (previous, current) => current is! ErrorBasketState && current is! LoadingBasketState,
              builder: (context, state) {
                return Scaffold(
                  body: ListView(
                    controller: basketItemScrollController,
                    physics: ClampingScrollPhysics(),
                    children: [
                      ListView.separated(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          indent: 130.0,
                          endIndent: 20.0,
                          color: Colors.black26,
                        ),
                        itemCount: state.calculatedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          BasketItem item = state.calculatedItems[index];

                          if (pageWidth > 1000) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                              child: _buildListItem(context, item, index),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                              child: _buildListItemPortrait(context, item, index),
                            );
                          }
                        },
                      ),

                      //Button Back
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: OutlinedButton.icon(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: Color(0xFF1F5FFF),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.keyboard_return,
                                size: 24,
                                color: Color(0xFF1F5FFF),
                              ),
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'text.continue_shopping'.tr(),
                                  style: Theme.of(context).textTheme.normal.copyWith(
                                        color: Color(0xFF1F5FFF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  floatingActionButton: CustomBackToTopButton(scrollController: basketItemScrollController),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, BasketItem item, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemImage(context, item),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: _buildItemDetail(context, item),
                  ),
                ),
                if (item.isShowItemControl()) _buildItemControl(context, item, index),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItemPortrait(BuildContext context, BasketItem item, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemImage(context, item),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildItemDetail(context, item),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _buildItemControl(context, item, index),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemImage(BuildContext context, BasketItem item) {
    if (item.isShowImage()) {
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Container(
          width: 100.0,
          height: 100.0,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadeInImage(
                image: item.isLocalImage() ? AssetImage(item.getImageUrl()) : NetworkImage(ImageUtil.getFullURL(item.getImageUrl())),
                fit: BoxFit.fill,
                placeholder: AssetImage('assets/images/non_article_image.png'),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/non_article_image.png',
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 108.0,
      );
    }
  }

  Widget _buildItemDetail(BuildContext context, BasketItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.getArticleDesc(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.large,
        ),
        if (item.isShowArticleId())
          Text(
            'SKU: ${item.getArticleId()}',
            style: Theme.of(context).textTheme.normal.copyWith(color: Colors.grey),
          ),
        _buildPrice(context, item),
        _buildMappingCheckList(context, item),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, BasketItem item) {
    bool showPromotionPrice = false;
    String priceText = '';
    Color txtColor = colorDark;

    if (item.isFreeItem) {
      txtColor = Colors.red;
      priceText = 'text.free'.tr();
    } else if (item.getPromotionPrice() != null) {
      showPromotionPrice = true;
      txtColor = Colors.red;
      priceText = StringUtil.getDefaultCurrencyFormat(item.getPromotionPrice());
    } else {
      priceText = StringUtil.getDefaultCurrencyFormat(item.getNormalPrice());
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          if (showPromotionPrice)
            TextSpan(
              text: '${StringUtil.getDefaultCurrencyFormat(item.getNormalPrice())}',
              style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough),
            ),
          if (showPromotionPrice)
            TextSpan(
              text: ' ',
            ),
          TextSpan(
            text: priceText,
            style: Theme.of(context).textTheme.large.copyWith(
                  fontWeight: FontWeight.bold,
                  color: txtColor,
                ),
          ),
          TextSpan(
            text: ' ',
          ),
          if (!item.isFreeItem)
            TextSpan(
              text: 'text.baht'.tr(),
              style: Theme.of(context).textTheme.normal,
            ),
        ],
      ),
    );
  }

  Widget _buildItemControl(BuildContext context, BasketItem item, int index) {
    return Row(
      children: [
        EditQtyPanel(item),
        if (item.isRemovableItem())
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Material(
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: IconButton(
                  icon: const Icon(MdiIcons.trashCanOutline),
                  color: Colors.white,
                  onPressed: () {
                    onRemoveItem(item);
                  },
                ),
              ),
            ),
          ),
        if (!item.isRemovableItem())
          Container(
            width: 60.0,
          )
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return BlocBuilder<BasketBloc, BasketState>(
        condition: (previous, current) => current is! ErrorBasketState && current is! LoadingBasketState,
        builder: (context, state) {
          return Container(
            constraints: BoxConstraints(minWidth: 350),
            width: 360,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'text.summary_price'.tr(),
                          style: Theme.of(context).textTheme.larger.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'text.total_price'.tr(),
                            style: Theme.of(context).textTheme.normal,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                StringUtil.getDefaultCurrencyFormat(state.netTrnAmt),
                                style: Theme.of(context).textTheme.normal,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Text(
                            'text.baht'.tr(),
                            style: Theme.of(context).textTheme.normal,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'text.delivery_fee'.tr(),
                            style: Theme.of(context).textTheme.normal,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                StringUtil.getDefaultCurrencyFormat(state.deliveryFeeAmt),
                                style: Theme.of(context).textTheme.normal,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Text(
                            'text.baht'.tr(),
                            style: Theme.of(context).textTheme.normal,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'text.total_discount'.tr(),
                            style: Theme.of(context).textTheme.normal,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                StringUtil.getDefaultCurrencyFormat(state.totalDiscountAmt),
                                style: Theme.of(context).textTheme.normal,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Text(
                            'text.baht'.tr(),
                            style: Theme.of(context).textTheme.normal,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'text.net_amount'.tr(),
                            style: Theme.of(context).textTheme.normal,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                StringUtil.getDefaultCurrencyFormat(state.unpaidAmt),
                                style: Theme.of(context).textTheme.xlarger.copyWith(
                                      color: colorGreen2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Text(
                            'text.baht'.tr(),
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: colorBlue7,
                                  padding: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: BlocProvider.of<BasketBloc>(context).state.items.isNotEmpty ? () => onPay() : null,
                                child: Text(
                                  'text.pay_now'.tr(),
                                  style: Theme.of(context).textTheme.normal.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: colorAccent,
                                  padding: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: BlocProvider.of<BasketBloc>(context).state.items.isNotEmpty ? () => onPayAtCashier() : null,
                                child: Text(
                                  'text.continue.by.cashier'.tr(),
                                  style: Theme.of(context).textTheme.normal.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildPolicy(context),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _buildPolicy(BuildContext context) {
    return BlocBuilder<ConsentPolicyBloc, ConsentPolicyState>(builder: (context, state) {
      if (state is LoadingConsentPolicyState) return CircularProgressIndicator();
      if (state is SuccessConsentPolicyState) {
        List<ConsentLists> consents = state.getListPolicyByLanguage(context);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Text(
                    'text.policy'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: consents.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: InkWell(
                    child: Text(
                      '${consents[index].consentName} >',
                      style: Theme.of(context).textTheme.smaller.copyWith(
                            decoration: TextDecoration.underline,
                            color: colorGrey1,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    onTap: () {
                      DialogUtil.showCustomDialog(
                        context,
                        child: PolicyPanel(
                          consentLists: consents[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      }

      return Container();
    });
  }

  String number = '';

  Widget _buildMappingCheckList(BuildContext context, BasketItem item) {
    if (item.checkListData == null) {
      return SizedBox.shrink();
    }

    return Container(
      color: colorBlue5,
      width: 280,
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                MdiIcons.clipboardCheckOutline,
                color: Color(0xFF1F5FFF),
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text('text.header_checklist'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Color(0xFF1F5FFF))),
            ],
          ),
          SizedBox(
            width: 25,
          ),
          InkWell(
            child: Row(
              children: [
                Text('text.edit'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF1F5FFF),
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
            onTap: () {
              onEditCheckList(item);
            },
          ),
        ],
      ),
    );
  }

  Widget buildCompleteCashier(String phoneNo) {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

    return Container(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            NovaLineIcon.interface_alert_circle,
            color: colorBlue7,
            size: 30,
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              'text.reserve.by.staff'.tr(),
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorBlue7,
                  ),
            ),
          ),
          Text(
            'text.reserve.by.staff.desr'.tr(namedArgs: {"newLine": "\n"}),
            style: Theme.of(context).textTheme.normal.copyWith(color: colorGrey1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Card(
            elevation: 8,
            shadowColor: colorGreyBlueShadow,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'common.telephone'.tr(),
                    style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(phoneNo),
                    style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Image.asset('assets/images/${context.locale.toString()}/payatcashire.png'),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 480,
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
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'text.reserve.queue.by.yourself'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRemoveItem(String textDesc) {
    return Container(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('text.confirm_remove_item'.tr(), style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            textDesc,
            style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    child: Text(
                      'text.back'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
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
                    child: Text(
                      'common.dialog_button_ok'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditQtyPanel extends StatefulWidget {
  final BasketItem item;

  const EditQtyPanel(this.item, {Key key}) : super(key: key);

  @override
  _EditQtyPanel createState() => _EditQtyPanel();
}

class _EditQtyPanel extends State<EditQtyPanel> {
  TextEditingController _textEditingController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.item.qty.toString();
    _textEditingController.selection = TextSelection.collapsed(offset: _textEditingController.text.length);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _textEditingController.text = widget.item.qty.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuantityControl(
      incrValue: 1,
      editController: _textEditingController,
      minValue: 0,
      maxValue: 9999,
      enable: widget.item.isEditableQty(),
      callBackIncr: (val) {
        BlocProvider.of<BasketBloc>(context).add(
          BasketUpdateItemEvent(widget.item, val),
        );
      },
      callBackDecr: (val) {
        if (val == 0) val = 1;
        BlocProvider.of<BasketBloc>(context).add(
          BasketUpdateItemEvent(widget.item, val),
        );
      },
      callBackChange: (val) {
        if (val == 0) return;
        BlocProvider.of<BasketBloc>(context).add(
          BasketUpdateItemEvent(widget.item, val),
        );
      },
    );
  }
}

class CashierPayment extends StatefulWidget {
  _CashierPayment createState() => _CashierPayment();
}

class _CashierPayment extends State<CashierPayment> {
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  setValue(String val) {
    if (searchController.text.length < 10)
      setState(() {
        searchController.text += val;
      });
  }

  backspace(String text) {
    if (text.length > 0) {
      setState(() {
        searchController.text = text.split('').sublist(0, text.length - 1).join('');
      });
    }
  }

  void onSavePayAtCashier(String text) {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context, text);
      // widget.bloc.add(SaveSalesCartWithPhoneNoEvent(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'text.input.phone.for.pay.cashier'.tr(args: ["\n"]),
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    showCursor: false,
                    controller: searchController,
                    style: Theme.of(context).textTheme.large.copyWith(height: 2),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'text.enter.phone.number'.tr(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hoverColor: Colors.transparent,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (StringUtil.isNullOrEmpty(value)) {
                        return 'text.please.specify.phone.number'.tr();
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {});
                      }
                    },
                  ),
                ),
                Container(
                  width: 280,
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomNumberPad(
                            text: '1',
                            onPressed: () => setValue('1'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: '2',
                            onPressed: () => setValue('2'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: '3',
                            onPressed: () => setValue('3'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomNumberPad(
                            text: '4',
                            onPressed: () => setValue('4'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: '5',
                            onPressed: () => setValue('5'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: '6',
                            onPressed: () => setValue('6'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomNumberPad(
                            text: '7',
                            onPressed: () => setValue('7'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: '8',
                            onPressed: () => setValue('8'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: '9',
                            onPressed: () => setValue('9'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomNumberPad(
                            icon: NovaLineIcon.arrow_left_1,
                            onPressed: () => backspace(searchController.text),
                          ),
                          CustomNumberPad(
                            text: '0',
                            onPressed: () => setValue('0'),
                            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                          ),
                          CustomNumberPad(
                            text: 'text.save'.tr(),
                            backgroundColor: colorOrangeGradient2,
                            onPressed: searchController.text.length == 10 ? () => onSavePayAtCashier(searchController.text) : null,
                            style: Theme.of(context).textTheme.large.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PolicyPanel extends StatefulWidget {
  final ConsentLists consentLists;

  PolicyPanel({this.consentLists});

  @override
  _PolicyPanelState createState() => _PolicyPanelState();
}

class _PolicyPanelState extends State<PolicyPanel> {
  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

    return Container(
      width: 800,
      height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          buildHeader(context),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                buildHtmlContent(context),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: 480,
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
                Navigator.pop(context);
              },
              child: Text(
                'common.dialog_button_close'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      child: Text(
        widget.consentLists.consentName,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildHtmlContent(BuildContext context) {
    if (StringUtil.isNullOrEmpty(widget.consentLists.content)) {
      return Container();
    }

    return CustomHtml(htmlInput: widget.consentLists.content);
  }
}
