import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/calculate_promotion/calculate_promotion_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/check_stock_store/check_stock_store_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/compare_product/compare_product_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_compare/flag_compare_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/product/product_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_promotion/search_promotion_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_master_label_location_rs.dart' as MstLabelLocationRs;
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart' as CalProRs;
import 'package:flutter_store_catalog/core/models/salesprmtn/get_item_promotion_detail_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/views/web/salesguide.dart';
import 'package:flutter_store_catalog/ui/widgets/compare_product.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_checkbox.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_html.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_toggle_tab.dart';
import 'package:flutter_store_catalog/ui/widgets/more_discount.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/product_list.dart';
import 'package:flutter_store_catalog/ui/widgets/quantity_control.dart';
import 'package:flutter_store_catalog/ui/widgets/tender_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../router.dart';

class MenuButton {
  final String label;
  final IconData icon;
  final Function action;
  final bool isLoading;

  MenuButton(this.label, this.icon, this.action, {this.isLoading = false});
}

class ProductPage extends StatefulWidget {
  final ArticleList article;

  const ProductPage({Key key, this.article}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  static const int autoScrollTabIndex = 0;

  ArticleList articleDetail;

  AutoScrollController scrollController;
  String contentHtml;
  TextEditingController _qtyController = TextEditingController(text: "1");

  bool isMappingCheckList = false;

  void onDestinationSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  Future<void> onAddCart() async {
    if (StringUtil.isNullOrEmpty(_qtyController.text) || num.parse(_qtyController.text) == 0) {
      await DialogUtil.showWarningDialog(context, 'common.dialog_title_warning'.tr(), 'text.please_specify_product_qty'.tr());
      return;
    }

    bool isFoundArticleCheckList = BlocProvider.of<BasketBloc>(context).state.isFoundArticleCheckList(articleDetail);
    if (isMappingCheckList && !isFoundArticleCheckList) {
      bool isConfirmMappingCheckList;
      if (articleDetail?.isFreeInstall ?? false) {
        isConfirmMappingCheckList = await DialogUtil.showConfirmDialog(
          context,
          title: 'text.free_installation_service'.tr(),
          message: 'text.free_installation_service_detail'.tr(namedArgs: {"newLine": "\n"}),
          textOk: 'text.deli_and_installation'.tr(),
          textCancel: 'text.deli_only'.tr(),
        );
      } else {
        isConfirmMappingCheckList = await DialogUtil.showConfirmDialog(
          context,
          title: 'text.home_pro_installation_service'.tr(namedArgs: {"newLine": "\n"}),
          message: 'text.additional_charge'.tr(),
          textOk: 'text.deli_and_installation'.tr(),
          textCancel: 'text.deli_only'.tr(),
        );
      }

      if (isConfirmMappingCheckList == null) return; // skip close dialog

      if (isConfirmMappingCheckList) {
        // Confirm Add CheckList
        dynamic checkListData = await Navigator.pushNamed(
          context,
          WebRoutePaths.CheckList,
          arguments: {
            'article': articleDetail,
          },
        );

        if (checkListData == null) return; // skip back button

        BlocProvider.of<BasketBloc>(context).add(
          BasketAddItemEvent(BasketItem(articleDetail, num.parse(_qtyController.text), checkListData: checkListData), true),
        );
        return;
      }
    }

    // not mapping or won't check list
    BlocProvider.of<BasketBloc>(context).add(
      BasketAddItemEvent(BasketItem(articleDetail, num.parse(_qtyController.text)), true),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController();
  }

  @override
  dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (ctx) => ProductBloc(BlocProvider.of<ApplicationBloc>(context))
            ..add(
              ProductLoadEvent(widget.article),
            ),
        ),
        BlocProvider<CheckStockStoreBloc>(
          create: (ctx) => CheckStockStoreBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<SearchPromotionBloc>(
          create: (ctx) => SearchPromotionBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<CalculatePromotionBloc>(
          create: (ctx) => CalculatePromotionBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context), BlocProvider.of<BasketBloc>(context)),
        ),
      ],
      child: CommonLayout(
        isShowBack: true,
        bodyBackgroundColor: Colors.white,
        body: MultiBlocListener(
          listeners: [
            BlocListener<CheckStockStoreBloc, CheckStockStoreState>(
              listener: (context, state) async {
                if (state is ErrorCheckStockStoreState) {
                  DialogUtil.showErrorDialog(context, state.error);
                }
              },
            ),
            BlocListener<SearchPromotionBloc, SearchPromotionState>(
              listener: (context, state) async {
                if (state is ErrorSearchPromotionState) {
                  DialogUtil.showErrorDialog(context, state.error);
                }
              },
            ),
            BlocListener<CalculatePromotionBloc, CalculatePromotionState>(
              condition: (prevState, currentState) {
                if (prevState is LoadingCalculatePromotionState) {
                  DialogUtil.hideLoadingDialog(context);
                }
                return true;
              },
              listener: (context, state) async {
                if (state is ErrorCalculatePromotionState) {
                  DialogUtil.showErrorDialog(context, state.error);
                } else if (state is LoadingCalculatePromotionState) {
                  DialogUtil.showLoadingDialog(context);
                } else if (state is CheckPriceState) {
                  DialogUtil.showCustomDialog(
                    context,
                    child: SuggestTenderPanel(state.totalAmount, state.tenderList, state.otherTenderList, state.hirePurchaseMap),
                  );
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
                } else if (state.isPopWidget) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
          child: BlocConsumer<ProductBloc, ProductState>(
            listenWhen: (prevState, currentState) {
              if (prevState is LoadingProductState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is ErrorProductState) {
                DialogUtil.showErrorDialog(context, state.error);
              } else if (state is LoadingProductState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ProductLoadSuccessState) {
                BlocProvider.of<CheckStockStoreBloc>(context).add(GetStockStoreEvent(widget.article));
                BlocProvider.of<SearchPromotionBloc>(context).add(SearchPromotionEvent(widget.article));
              }
            },
            buildWhen: (previous, current) {
              return (current is InitialProductState || current is ProductLoadSuccessState);
            },
            builder: (context, state) {
              SearchPromotionRs searchPromotionRs;
              GetItemPromotionDetailRs itemPromotionDetail;

              if (state is ProductLoadSuccessState) {
                articleDetail = ArticleList();
                searchPromotionRs = SearchPromotionRs();
                articleDetail = state.article;
                contentHtml = state.htmlContent;
                isMappingCheckList = !StringUtil.isNullOrEmpty(state.insMappingId) ? true : false;
                itemPromotionDetail = state.itemPromotionDetail;
              }
              if (articleDetail == null || StringUtil.isNullOrEmpty(articleDetail.articleId)) {
                return SizedBox.shrink();
              }
              return Scaffold(
                body: Stack(
                  children: [
                    OrientationBuilder(
                      builder: (context, orientation) {
                        if (orientation == Orientation.landscape) {
                          return buildLandscape(articleDetail, searchPromotionRs, isMappingCheckList, itemPromotionDetail);
                        } else {
                          return buildPortrait(articleDetail, searchPromotionRs, isMappingCheckList, itemPromotionDetail);
                        }
                      },
                    ),
                    RightButtonBar(_qtyController),
                    BlocBuilder<FlagCompareBloc, FlagCompareState>(
                      builder: (context, state) {
                        if (state.isCompared) {
                          return BlocBuilder<CompareProductBloc, CompareProductState>(builder: (context, state) {
                            return CompareProduct(state.articleList);
                          });
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                floatingActionButton: BlocBuilder<FlagCompareBloc, FlagCompareState>(
                  builder: (context, state) {
                    if (state.isCompared) {
                      return CustomBackToTopButton(scrollController: scrollController, marginBottom: 115);
                    }
                    return CustomBackToTopButton(scrollController: scrollController);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildLandscape(ArticleList articleDetail, SearchPromotionRs searchPromotionRs, bool isMappingCheckList, GetItemPromotionDetailRs itemPromotionDetail) {
    if (articleDetail == null) {
      return SizedBox.shrink();
    }
    return ListView(
      controller: scrollController,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  ViewImagePanel(articleDetail.imageList),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(right: 80, top: 150),
                child: buildDetail(articleDetail, false, isMappingCheckList, itemPromotionDetail),
              ),
            ),
          ],
        ),
        Divider(
          color: colorDividerGrey,
          thickness: 1,
        ),
        StickyHeaderPanel(false, onDestinationSelected, this.scrollController, onAddCart, _qtyController),
      ],
    );
  }

  Widget buildPortrait(ArticleList articleDetail, SearchPromotionRs searchPromotionRs, bool isMappingCheckList, GetItemPromotionDetailRs itemPromotionDetail) {
    if (articleDetail == null) {
      return SizedBox.shrink();
    }
    return ListView(
      controller: scrollController,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ViewImagePanel(articleDetail.imageList),
            buildDetail(articleDetail, true, isMappingCheckList, itemPromotionDetail),
          ],
        ),
        Divider(
          color: colorDividerGrey,
          thickness: 1,
        ),
        StickyHeaderPanel(true, onDestinationSelected, this.scrollController, onAddCart, _qtyController),
      ],
    );
  }

  Widget buildDetail(ArticleList articleDetail, bool isPortrait, bool isMappingCheckList, GetItemPromotionDetailRs itemPromotionDetail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isPortrait ? 30 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CompareCheckboxPanel(articleDetail),
          buildStockReady(),
          buildTextRow(
              StringUtil.isNotEmpty(articleDetail.articleFullNameTH)
                  ? LanguageUtil.isTh(context)
                      ? articleDetail.articleFullNameTH
                      : articleDetail.articleFullNameEN
                  : LanguageUtil.isTh(context)
                      ? articleDetail.articleNameTH
                      : articleDetail.articleNameEN,
              Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold)),
          buildTextRow('text.sku.colon'.tr(args: ['${StringUtil.trimLeftZero(articleDetail.articleId)}']) + ', ' + 'text.menu_brand'.tr() + ': ' + '${articleDetail.brand}', Theme.of(context).textTheme.normal.copyWith(color: Colors.grey)),
          buildLocationProduct(),
          buildPrice(articleDetail, itemPromotionDetail?.discountAmt),
          buildPropertyMax3(articleDetail),
          AddCartPanel(
            article: articleDetail,
            isMappingCheckList: isMappingCheckList,
            onAddCart: onAddCart,
            qtyTextController: _qtyController,
          ),
          Divider(
            color: colorDividerGrey,
            thickness: 1,
          ),
          buildFreeGifts(itemPromotionDetail?.itemPromotionFreeGifts),
        ],
      ),
    );
  }

  Widget buildStockReady() {
    return BlocBuilder<CheckStockStoreBloc, CheckStockStoreState>(
      builder: (context, state) {
        if (state is LoadingCheckStockStoreState) return CircularProgressIndicator();
        if (state is GetStockStoreSuccessState && state.isThisStoreHaveStock) {
          return Container(
            width: 220,
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                Expanded(
                  child: Text(
                    'text.product.stock.ready'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget buildPrice(ArticleList articleDetail, num discountAmt) {
    String normalPrice = StringUtil.getDefaultCurrencyFormat(articleDetail.unitList[0].normalPrice);

    if (articleDetail.isHaveSpecialPrice()) {
      String specialPrice = StringUtil.getDefaultCurrencyFormat(articleDetail.unitList[0].promotionPrice);
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextRow(normalPrice, Theme.of(context).textTheme.normal.copyWith(decoration: TextDecoration.lineThrough)),
          Row(
            children: [
              Text('฿ ', style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold)),
              Text(
                specialPrice,
                style: Theme.of(context).textTheme.xxlarger.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.start,
              ),
              if ((discountAmt ?? 0) > 0) SizedBox(width: 40),
              if ((discountAmt ?? 0) > 0) MoreDiscount(discountPrice: discountAmt),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        buildTextRow('฿ $normalPrice', Theme.of(context).textTheme.xxlarger.copyWith(fontWeight: FontWeight.bold)),
        if ((discountAmt ?? 0) > 0) SizedBox(width: 40),
        if ((discountAmt ?? 0) > 0) MoreDiscount(discountPrice: discountAmt),
      ],
    );
  }

  Widget buildPropertyMax3(ArticleList articleDetail) {
    if (articleDetail == null || articleDetail.productPropertyList == null || articleDetail.productPropertyList.isEmpty) {
      return SizedBox.shrink();
    }
    List<String> productPropertyList = [];
    if (LanguageUtil.isTh(context)) {
      productPropertyList.addAll(articleDetail.productPropertyList[0].productPropertyListTH?.map((e) => e.productPropertyDesc)?.toList() ?? []);
    } else {
      productPropertyList.addAll(articleDetail.productPropertyList[0].productPropertyListEN?.map((e) => e.productPropertyDesc)?.toList() ?? []);
    }
    productPropertyList = productPropertyList.take(3).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productPropertyList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 8, 8),
                child: Icon(
                  Icons.circle,
                  color: colorDark,
                  size: 10,
                ),
              ),
              Expanded(
                child: Text(
                  productPropertyList[index],
                  style: Theme.of(context).textTheme.normal.copyWith(),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTextWithDot(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Icon(
              Icons.circle,
              color: colorDark,
              size: 10,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.normal,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFreeGifts(List<ItemPromotionFreeGift> itemPromotionFreeGifts) {
    if (itemPromotionFreeGifts.isNullOrEmpty) return SizedBox.shrink();
    return Column(
      children: [
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: itemPromotionFreeGifts.length,
            itemBuilder: (context, index) {
              ItemPromotionFreeGift itemPromotionFreeGift = itemPromotionFreeGifts[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        itemPromotionFreeGift.getItemImage(),
                        height: 100,
                        width: 90,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/${context.locale.toString()}/freegift.png',
                              width: 100,
                              height: 40,
                            ),
                            Text(
                              itemPromotionFreeGift.promotionArtcDesc,
                              style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Divider(
          color: colorDividerGrey,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buildTextRow(String text, TextStyle style) {
    return Text(
      text,
      style: style,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
    );
  }

  Widget buildLocationProduct() {
    return BlocBuilder<ProductBloc, ProductState>(
      condition: (previous, current) {
        return current is ProductLoadSuccessState;
      },
      builder: (context, state) {
        if (state is ProductLoadSuccessState && state.getMasterLabelLocationRs?.articleList?.first?.locationList?.first != null) {
          MstLabelLocationRs.LocationList location = state.getMasterLabelLocationRs?.articleList?.first?.locationList?.first;
          return Text(
            '${'text.location_product_at'.tr()} ${LanguageUtil.isTh(context) ? location.locationDescTH : location.locationDescEN}',
            style: Theme.of(context).textTheme.normal.copyWith(),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start,
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}

class ViewImagePanel extends StatefulWidget {
  final List<ImageList> pathImages;

  ViewImagePanel(this.pathImages);

  _ViewImagePanel createState() => _ViewImagePanel();
}

class _ViewImagePanel extends State<ViewImagePanel> {
  List<Widget> _cacheImages;
  String pathImageMedium;
  String pathImageLarge;
  num selectImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _cacheImages = getImages(widget.pathImages);
    pathImageMedium = getPathImage(0, 'MEDIUM');
    pathImageLarge = getPathImage(0, 'LARGE');
  }

  String getPathImage(num index, String type) {
    if (widget.pathImages.isEmpty) {
      return 'assets/images/non_article_image.png';
    }

    String pathImageLarge = widget.pathImages[index].imageLarge;
    String pathImageSmall = widget.pathImages[index].imageSmall;
    String pathImageMedium = widget.pathImages[index].imageMedium;

    if (StringUtil.isNotEmpty(pathImageLarge) || StringUtil.isNotEmpty(pathImageSmall) || StringUtil.isNotEmpty(pathImageMedium)) {
      String pathImage;
      if (widget.pathImages.length == 0) {
        if (StringUtil.isNotEmpty(pathImageMedium)) {
          pathImage = pathImageMedium;
        } else if (StringUtil.isNotEmpty(pathImageLarge)) {
          pathImage = pathImageLarge;
        } else {
          pathImage = pathImageSmall;
        }
      } else {
        if (StringUtil.isNotEmpty(pathImageSmall)) {
          pathImage = pathImageSmall;
        } else if (StringUtil.isNotEmpty(pathImageMedium)) {
          pathImage = pathImageMedium;
        } else {
          pathImage = pathImageLarge;
        }
      }

      String pathImageDialogFullScreen;
      if (StringUtil.isNotEmpty(pathImageLarge)) {
        pathImageDialogFullScreen = pathImageLarge;
      } else if (StringUtil.isNotEmpty(pathImageMedium)) {
        pathImageDialogFullScreen = pathImageMedium;
      } else {
        pathImageDialogFullScreen = pathImageSmall;
      }

      String pathImageMed;
      if (StringUtil.isNotEmpty(pathImageMedium)) {
        pathImageMed = pathImageLarge;
      } else if (StringUtil.isNotEmpty(pathImageLarge)) {
        pathImageMed = pathImageMedium;
      } else {
        pathImageMed = pathImageSmall;
      }

      if ("LARGE" == type) return pathImageDialogFullScreen;
      if ("MEDIUM" == type) return pathImageMed;
      if ("SMALL" == type) return pathImage;
    }
    return 'assets/images/non_article_image.png';
  }

  onViewFullImage() {
    DialogUtil.showCustomDialog(context,
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width ? MediaQuery.maybeOf(context).size.width * 0.8 : MediaQuery.maybeOf(context).size.height * 0.8,
              width: MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width ? MediaQuery.maybeOf(context).size.width * 0.8 : MediaQuery.maybeOf(context).size.height * 0.8,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                imageProvider: NetworkImage(
                  ImageUtil.getFullURL(pathImageLarge),
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/non_article_image.png');
                },
              ),
            ),
          ],
        ));
  }

  onChangeImage(num index, String pathLarge, String pathMedium) {
    setState(() {
      pathImageLarge = pathLarge;
      pathImageMedium = pathMedium;
      selectImageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildImage();
  }

  Widget buildImage() {
    if (_cacheImages == null || _cacheImages.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: OutlinedButton(
                onPressed: () {
                  onViewFullImage();
                },
                child: Container(
                  child: Image.network(
                    ImageUtil.getFullURL(pathImageMedium),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/non_article_image.png');
                    },
                  ),
                ),
              ),
            ),
            Container(height: 100, child: ListView(scrollDirection: Axis.horizontal, children: buildImageDisplay())),
          ],
        ),
      ),
    );
  }

  List<Widget> buildImageDisplay() {
    List<Widget> resultWidget = [];
    for (int i = 0; i < _cacheImages.length; i++) {
      resultWidget.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          elevation: 8,
          child: Container(
            height: 100,
            width: 100,
            child: _cacheImages[i],
          ),
        ),
      ));
    }

    return resultWidget;
  }

  List<Widget> getImages(List<ImageList> pathImages) {
    List<Widget> imageResults = [];
    for (var i = 0; i < pathImages.length; i++) {
      String pathImageDialogFullScreen = getPathImage(i, 'LARGE');
      String pathImageMed = getPathImage(i, 'MEDIUM');

      imageResults.add(
        OutlinedButton(
          onPressed: () => onChangeImage(i, pathImageDialogFullScreen, pathImageMed),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/non_article_image.png',
            image: ImageUtil.getFullURL(getPathImage(i, 'SMALL')),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/non_article_image.png');
            },
          ),
        ),
      );
    }

    if (imageResults.isEmpty) {
      imageResults.add(
        Image.asset('assets/images/non_article_image.png'),
      );
    }

    return imageResults;
  }
}

class AddCartPanel extends StatefulWidget {
  final ArticleList article;
  final bool isMappingCheckList;
  final TextEditingController qtyTextController;
  final Function onAddCart;

  const AddCartPanel({Key key, this.article, this.isMappingCheckList, this.qtyTextController, this.onAddCart}) : super(key: key);

  @override
  _AddCartPanelState createState() => _AddCartPanelState();
}

class _AddCartPanelState extends State<AddCartPanel> {
  @override
  Widget build(BuildContext context) {
    return buildAddCart(widget.article, widget.isMappingCheckList);
  }

  Widget buildAddCart(ArticleList article, bool isMappingCheckList) {
    return Row(
      children: [
        QuantityControl(
          editController: widget.qtyTextController,
          incrValue: 1,
          minValue: 0,
          maxValue: 9999,
          callBackIncr: (val) {
            setState(() {
              widget.qtyTextController.text = val.toString();
            });
          },
          callBackDecr: (val) {
            setState(() {
              widget.qtyTextController.text = val.toString();
            });
          },
          callBackChange: (val) {
            setState(() {
              widget.qtyTextController.text = val.toString();
            });
          },
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorBlue7,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60),
          ),
          onPressed: (StringUtil.isNotEmpty(widget.qtyTextController.text) && num.parse(widget.qtyTextController.text) > 0) ? widget.onAddCart : null,
          child: Text(
            'text.add_to_cart'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class StickyHeaderPanel extends StatefulWidget {
  final bool isPortrait;
  final ValueChanged<int> onDestinationSelected;
  AutoScrollController scrollController;
  final Function onAddCart;
  final TextEditingController qtyController;

  StickyHeaderPanel(this.isPortrait, this.onDestinationSelected, this.scrollController, this.onAddCart, this.qtyController);

  _StickyHeaderPanel createState() => _StickyHeaderPanel();
}

class _StickyHeaderPanel extends State<StickyHeaderPanel> with TickerProviderStateMixin {
  TabController tabController;
  TabController tabProductDetail;
  bool isMorePadding = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabProductDetail = TabController(length: 3, vsync: this, initialIndex: 0);

    tabProductDetail.addListener(onHandleTabSelection);
    widget.scrollController.addListener(onScroll);
  }

  onScroll() {
    // print(widget.scrollController.position.pixels);
    // setState(() {});
  }

  onHandleTabSelection() {
    if (tabProductDetail.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  dispose() {
    tabController.dispose();
    tabProductDetail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      condition: (previous, current) {
        return current is ProductLoadSuccessState;
      },
      builder: (context, state) {
        if (state is ProductLoadSuccessState) {
          return buildStickyHeader(state.article, state.htmlContent);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget buildStickyHeader(ArticleList articleDetail, String contentHtml) {
    if (widget.isPortrait) {
      return buildPortrait(articleDetail, contentHtml);
    } else {
      return buildLandScape(articleDetail, contentHtml);
    }
  }

  Widget buildLandScape(ArticleList articleDetail, String contentHtml) {
    return StickyHeaderBuilder(
      overlapHeaders: true,
      builder: (BuildContext context, double stuckAmount) {
        stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
        return Column(
          children: [
            Container(
              child: Stack(
                children: <Widget>[
                  _buildTabBarDetail(),
                  Offstage(
                    offstage: stuckAmount <= 0.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHoverCart(articleDetail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      content: Container(
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.only(bottom: BlocProvider.of<FlagCompareBloc>(context).state.isCompared ? 110 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildProductProperties(articleDetail, contentHtml, false),
            buildProductSimilar(),
            buildProductInterest(),
          ],
        ),
      ),
    );
  }

  Widget buildPortrait(ArticleList articleDetail, String contentHtml) {
    return StickyHeaderBuilder(
      overlapHeaders: true,
      builder: (BuildContext context, double stuckAmount) {
        stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
        return Container(
          child: Column(
            children: <Widget>[
              _buildTabBarDetail(),
              Offstage(
                offstage: stuckAmount <= 0.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHoverCart(articleDetail),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      content: Container(
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.only(bottom: BlocProvider.of<FlagCompareBloc>(context).state.isCompared ? 110 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildProductProperties(articleDetail, contentHtml, true),
            buildProductSimilar(),
            buildProductInterest(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarDetail() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        List<String> tabs = [
          'text.product_info'.tr(),
        ];

        if (state is ProductLoadSuccessState) {
          if (state.lstSimilarProduct != null && state.lstSimilarProduct.length > 0) tabs.add('text.similar_product'.tr());
          if (state.lstInterestProduct != null && state.lstInterestProduct.length > 0) tabs.add('text.interest_product'.tr());
        }

        // Reset Count Tab
        tabController = TabController(length: tabs.length, vsync: this, initialIndex: tabController.index);

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorGrey4.withOpacity(0.9),
          ),
          child: Align(
            alignment: Alignment.center,
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: colorGrey1,
              labelColor: colorBlue7,
              indicatorColor: Colors.transparent,
              controller: tabController,
              tabs: tabs
                  .map((e) => Tab(
                          child: Text(
                        e,
                        style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                      )))
                  .toList(),
              onTap: (index) {
                widget.onDestinationSelected(index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildProductProperties(ArticleList articleDetail, String contentHtml, bool isPortrait) {
    List<String> tabs = [
      'text.product.property'.tr(),
    ];

    if (articleDetail != null) {
      if (articleDetail.featureList.isNotNE) tabs.add('text.product.feature'.tr());
      // if (searchPromotionRs != null && searchPromotionRs.promotions.isNotNE) tabs.add('text.promotion_relate'.tr());
    }
    tabs.add('text.promotion_relate'.tr());

    // Reset Count Tab
    tabProductDetail = TabController(length: tabs.length, vsync: this, initialIndex: tabProductDetail.index);
    tabProductDetail.addListener(onHandleTabSelection);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AutoScrollTag(
          key: ValueKey(0),
          controller: widget.scrollController,
          index: 0,
          child: Container(height: 60),
        ),
        Container(
          width: 750,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorGrey3,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomToggleTab(
            selection: (value) => {},
            tabController: tabProductDetail,
            names: tabs,
            selectedTextStyle: Theme.of(context).textTheme.normal.copyWith(
                  color: colorBlue7,
                  fontWeight: FontWeight.bold,
                ),
            unSelectedTextStyle: Theme.of(context).textTheme.normal.copyWith(
                  color: colorGrey2,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * (isPortrait ? 0.9 : 0.7),
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: [
            buildChildCardArticleDetail(articleDetail, contentHtml, isPortrait),
            if (articleDetail.featureList.isNotNE) buildChildCardFeature(articleDetail, isPortrait),
            buildChildCardPromotion(isPortrait),
          ][tabProductDetail.index],
        ),
      ],
    );
  }

  // สินค้าใกล้เคียง
  Widget buildProductSimilar() {
    return Column(
      children: [
        AutoScrollTag(
          key: ValueKey(1),
          controller: widget.scrollController,
          index: 1,
          child: Container(height: 50),
        ),
        BlocBuilder<ProductBloc, ProductState>(
          condition: (previous, current) {
            return current is ProductLoadSuccessState;
          },
          builder: (context, state) {
            if (state is ProductLoadSuccessState) {
              return buildArtList('text.similar_product'.tr(), state.lstSimilarProduct);
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // สินค้าที่คุณอาจสนใจ
  Widget buildProductInterest() {
    return Column(
      children: [
        AutoScrollTag(
          key: ValueKey(2),
          controller: widget.scrollController,
          index: 2,
          child: Container(),
        ),
        BlocBuilder<ProductBloc, ProductState>(
          condition: (previous, current) {
            return current is ProductLoadSuccessState;
          },
          builder: (context, state) {
            if (state is ProductLoadSuccessState) {
              return buildArtList('text.interest_product'.tr(), state.lstInterestProduct);
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget buildArtList(String headerName, List<ArticleList> listArts) {
    if (listArts == null || listArts.length == 0) return Container();

    return Padding(
      padding: const EdgeInsets.only(left: 28, right: 80, top: 30, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            headerName,
            style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
          ),
          BlocBuilder<FlagCompareBloc, FlagCompareState>(
            builder: (context, state) {
              return Container(
                height: (state.isCompared ?? false) ? 440.0 : 410.0,
                child: Center(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listArts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 300,
                        child: ProductItem(article: listArts[index], indexItem: index),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextHeaderAndDesc(String label, String data) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text(
              label ?? '',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: Text(
              data ?? '',
              style: Theme.of(context).textTheme.normal,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextWithDot(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Icon(
              Icons.circle,
              color: Colors.black,
              size: 10,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.normal,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  //รายละเอียดสินค้า
  Widget buildChildCardArticleDetail(ArticleList articleDetail, String contentHtml, bool isPortrait) {
    if (isPortrait) {
      return ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          buildArticleDetailUsage(articleDetail, contentHtml),
          buildProperty(articleDetail),
          buildProductUsage(articleDetail),
          buildProductTips(articleDetail),
          buildProductSafety(articleDetail),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildArticleDetailUsage(articleDetail, contentHtml),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  buildProperty(articleDetail),
                  buildProductUsage(articleDetail),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  buildProductTips(articleDetail),
                  buildProductSafety(articleDetail),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildArticleDetailUsage(ArticleList articleDetail, String contentHtml) {
    if (StringUtil.isNullOrEmpty(contentHtml)) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomHtml(
        htmlInput: contentHtml,
      ),
    );
  }

  Widget buildProperty(ArticleList articleDetail) {
    if (articleDetail == null || articleDetail.productPropertyList == null || articleDetail.productPropertyList.isEmpty) {
      return SizedBox.shrink();
    }
    List<String> productPropertyList = [];
    if (LanguageUtil.isTh(context)) {
      productPropertyList.addAll(articleDetail.productPropertyList[0].productPropertyListTH?.map((e) => e.productPropertyDesc)?.toList() ?? []);
    } else {
      productPropertyList.addAll(articleDetail.productPropertyList[0].productPropertyListEN?.map((e) => e.productPropertyDesc)?.toList() ?? []);
    }

    if (productPropertyList.isNullOrEmpty) return SizedBox.shrink();

    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Text(
                'text.feature'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              ),
            )),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: productPropertyList.length,
          itemBuilder: (context, index) {
            return buildTextWithDot(
              productPropertyList[index],
            );
          },
        ),
      ],
    );

    // return Column(children: [
    //   Container(
    //       alignment: Alignment.centerLeft,
    //       child: Padding(
    //         padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
    //         child: Text(
    //           'text.feature'.tr(),
    //           style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
    //         ),
    //       )),
    //   ListView.builder(
    //       shrinkWrap: true,
    //       physics: ClampingScrollPhysics(),
    //       itemCount: enLength,
    //       itemBuilder: (context, index) {
    //         ProductPropertyListEN property = articleDetail.productPropertyList[0].productPropertyListEN[index];
    //         return Padding(
    //           padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Icon(
    //                 Icons.circle,
    //                 color: Colors.black,
    //                 size: 5,
    //               ),
    //               Expanded(
    //                 child: Text(
    //                   property.productPropertyDesc,
    //                   style: Theme.of(context).textTheme.normal,
    //                   overflow: TextOverflow.clip,
    //                   textAlign: TextAlign.start,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       })
    // ]);
  }

  Widget buildProductUsage(ArticleList articleDetail) {
    if (articleDetail == null || articleDetail.productUsageList == null || articleDetail.productUsageList.isEmpty) {
      return SizedBox.shrink();
    }
    ProductUsageList productUsage = articleDetail.productUsageList[0];
    int lengthTh = productUsage.productUsageListTH == null || productUsage.productUsageListTH.isEmpty ? 0 : productUsage.productUsageListTH.length;
    int lengthEn = productUsage.productUsageListEN == null || productUsage.productUsageListEN.isEmpty ? 0 : productUsage.productUsageListEN.length;
    int length = LanguageUtil.isTh(context) ? lengthTh : lengthEn;

    if (length == 0) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Text(
                'text.how_to_use'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              ),
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  buildTextWithDot(
                    LanguageUtil.isTh(context) ? productUsage.productUsageListTH[index].productUsageDesc : productUsage.productUsageListEN[index].productUsageDesc,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    //child: const Divider(height: 1, thickness: 2, indent: 1, endIndent: 0),
                  ),
                ],
              );
            }),
      ],
    );
  }

  Widget buildProductTips(ArticleList articleDetail) {
    if (articleDetail == null || articleDetail.productTipsList == null || articleDetail.productTipsList.isEmpty) {
      return SizedBox.shrink();
    }
    ProductTipsList productTips = articleDetail.productTipsList[0];
    int lengthTh = productTips.productTipsListTH == null || productTips.productTipsListTH.isEmpty ? 0 : productTips.productTipsListTH.length;
    int lengthEn = productTips.productTipsListEN == null || productTips.productTipsListEN.isEmpty ? 0 : productTips.productTipsListEN.length;
    int length = LanguageUtil.isTh(context) ? lengthTh : lengthEn;

    if (length == 0) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'text.recommend'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              )),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  buildTextWithDot(
                    LanguageUtil.isTh(context) ? productTips.productTipsListTH[index].productTipsDesc : productTips.productTipsListEN[index].productTipsDesc,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    //child: const Divider(height: 1, thickness: 2, indent: 1, endIndent: 0),
                  ),
                ],
              );
            }),
      ],
    );
  }

  Widget buildProductSafety(ArticleList articleDetail) {
    if (articleDetail == null || articleDetail.productSafetyList == null || articleDetail.productSafetyList.isEmpty) {
      return SizedBox.shrink();
    }
    ProductSafetyList productSafety = articleDetail.productSafetyList[0];
    int lengthTh = productSafety.productSafetyListTH == null || productSafety.productSafetyListTH.isEmpty ? 0 : productSafety.productSafetyListTH.length;
    int lengthEn = productSafety.productSafetyListEN == null || productSafety.productSafetyListEN.isEmpty ? 0 : productSafety.productSafetyListEN.length;
    int length = LanguageUtil.isTh(context) ? lengthTh : lengthEn;

    if (length == 0) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Text(
                'text.caution'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              ),
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  buildTextWithDot(LanguageUtil.isTh(context) ? productSafety.productSafetyListTH[index].productSafetyDesc : productSafety.productSafetyListEN[index].productSafetyDesc),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                  ),
                ],
              );
            }),
      ],
    );
  }

  Widget buildChildCardFeature(ArticleList articleDetail, bool isPortrait) {
    if (articleDetail == null || articleDetail.featureList == null || articleDetail.featureList.isEmpty) {
      return SizedBox.shrink();
    }
    if (isPortrait) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: articleDetail.featureList.length,
              itemBuilder: (context, index) {
                FeatureList feature = articleDetail.featureList[index];
                return buildFeatureRow(feature);
              },
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: articleDetail.featureList.length,
            itemBuilder: (context, index) {
              if (index < MathUtil.divide(articleDetail.featureList.length, 2)) {
                return buildFeatureRow(articleDetail.featureList[index]);
              }
              return SizedBox.shrink();
            },
          ),
        ),
        SizedBox(
          width: 50,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: articleDetail.featureList.length,
            itemBuilder: (context, index) {
              if (index >= MathUtil.divide(articleDetail.featureList.length, 2)) {
                return buildFeatureRow(articleDetail.featureList[index]);
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildFeatureRow(FeatureList feature) {
    return Column(
      children: [
        buildTextHeaderAndDesc(
          LanguageUtil.isTh(context) ? feature.featureNameTH : feature.featureNameEN,
          LanguageUtil.isTh(context) ? feature.featureDescTH : feature.featureDescEN,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: const Divider(height: 1, thickness: 2, indent: 1, endIndent: 0),
        ),
      ],
    );
  }

  Widget buildChildCardPromotion(bool isPortrait) {
    return BlocBuilder<SearchPromotionBloc, SearchPromotionState>(
      builder: (context, state) {
        if (state is LoadingSearchPromotionState)
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(color: colorBlue7),
              ),
            ],
          );
        else if (state is SearchPromotionSuccessState) {
          List<Promotions> promotions = state.searchPromotions;
          if (promotions == null || promotions.isEmpty) {
            return SizedBox.shrink();
          }
          if (isPortrait) {
            return ListView.separated(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 2,
              ),
              itemCount: promotions.length,
              itemBuilder: (context, index) => buildPromotion(promotions.elementAt(index)),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    if (index < MathUtil.divide(promotions.length, 2)) {
                      return Divider(
                        thickness: 2,
                      );
                    }
                    return SizedBox.shrink();
                  },
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    if (index < MathUtil.divide(promotions.length, 2)) {
                      return buildPromotion(promotions.elementAt(index));
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    if (index >= MathUtil.divide(promotions.length, 2)) {
                      return Divider(
                        thickness: 2,
                      );
                    }
                    return SizedBox.shrink();
                  },
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    if (index >= MathUtil.divide(promotions.length, 2)) {
                      return buildPromotion(promotions.elementAt(index));
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget buildPromotion(Promotions promotion) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${promotion.name}',
            style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          Text(
            'text.period_since'.tr(args: ['${promotion.getDisplayDate()}']),
            style: Theme.of(context).textTheme.normal.copyWith(color: colorGrey2),
            textAlign: TextAlign.start,
          ),
          Text(
            '${promotion.promotionId}',
            style: Theme.of(context).textTheme.normal,
          ),
          Text(
            '${promotion.description}',
            style: Theme.of(context).textTheme.normal,
          ),
        ],
      ),
    );
  }

  Widget buildHoverCart(ArticleList articleDetail) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        height: 120,
        width: 300,
        child: Card(
          shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.0),
                        boxShadow: [
                          BoxShadow(
                            color: colorGrey4,
                            offset: Offset(0, 0.5),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/non_article_image.png',
                        image: ImageUtil.getFullURL(articleDetail.imageList.isNullOrEmpty ? '' : articleDetail.imageList.first.imageSmall),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/non_article_image.png');
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextPrice(articleDetail),
                        if (StringUtil.isNotEmpty(widget.qtyController.text) && num.parse(widget.qtyController.text) > 0)
                          InkWell(
                            onTap: widget.onAddCart,
                            child: Text(
                              '+ ' + 'text.add_to_cart'.tr(),
                              style: Theme.of(context).textTheme.normal.copyWith(
                                    color: colorBlue7,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextPrice(ArticleList articleDetail) {
    String price = StringUtil.getDefaultCurrencyFormat(articleDetail.unitList[0].normalPrice);

    if (articleDetail.isHaveSpecialPrice()) {
      price = StringUtil.getDefaultCurrencyFormat(articleDetail.unitList[0].promotionPrice);
    }
    return Row(
      children: [
        Text('฿ ', style: Theme.of(context).textTheme.xxlarger.copyWith(fontWeight: FontWeight.bold)),
        Text(
          price,
          style: Theme.of(context).textTheme.xxlarger.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class CompareCheckboxPanel extends StatefulWidget {
  final ArticleList articleDetail;

  const CompareCheckboxPanel(this.articleDetail, {Key key}) : super(key: key);

  @override
  _CompareCheckboxPanelState createState() => _CompareCheckboxPanelState();
}

class _CompareCheckboxPanelState extends State<CompareCheckboxPanel> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlagCompareBloc, FlagCompareState>(
      builder: (context, state) {
        if (!state.isCompared) {
          return Container();
        }
        return buildCheckBoxCompare(widget.articleDetail);
      },
    );
  }

  Widget buildCheckBoxCompare(ArticleList articleDetail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          BlocBuilder<CompareProductBloc, CompareProductState>(
            builder: (context, state) {
              return CustomCheckbox(
                value: state.articleList.where((e) => e.articleId == articleDetail.articleId).isNotEmpty,
                onChanged: (value) {
                  if (value) {
                    if (state.articleList.length >= 4) {
                      DialogUtil.showWarningDialog(context, 'common.dialog_title_warning'.tr(), 'warning.max_four_items'.tr());
                      setState(() {
                        value = !value;
                      });
                      return;
                    }

                    BlocProvider.of<CompareProductBloc>(context).add(
                      AddProductCompareEvent(articleDetail),
                    );
                  } else {
                    BlocProvider.of<CompareProductBloc>(context).add(
                      RemoveProductCompareEvent(state.articleList.indexWhere((e) => e.articleId == articleDetail.articleId)),
                    );
                  }
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              'text.filter_compare'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    color: colorBlue7,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class RightButtonBar extends StatefulWidget {
  TabController payCashierByTabController;
  final TextEditingController qtyTextController;

  RightButtonBar(this.qtyTextController);

  _RightButtonBar createState() => _RightButtonBar();
}

class _RightButtonBar extends State<RightButtonBar> with TickerProviderStateMixin {
  List<MenuButton> menuList;

  @override
  void initState() {
    super.initState();

    widget.payCashierByTabController = TabController(length: 2, vsync: this);

    menuList = [
      MenuButton('text.cal_promotion'.tr(args: ['\n']), NovaLineIcon.credit_card_dollar, onCalculatePromotion),
      MenuButton('text.view_stock'.tr(args: ['\n']), NovaLineIcon.warehouse_box, onCheckStock),
      MenuButton('text.filter_compare'.tr(), NovaLineIcon.move_left_right_1, onCompare),
      // MenuButton('text.calculate'.tr(), NovaLineIcon.calculator_2, onCalculate),
    ];
  }

  @override
  dispose() {
    widget.payCashierByTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (productContext, productState) => BlocBuilder<CalculatePromotionBloc, CalculatePromotionState>(
          builder: (calProContext, calProState) => BlocBuilder<CheckStockStoreBloc, CheckStockStoreState>(
            builder: (stockContext, stockState) {
              bool isShowStock = stockState is LoadingCheckStockStoreState || stockState is GetStockStoreSuccessState && stockState.stockStoreList.isNotEmpty;
              if (productState is ProductLoadSuccessState) {
                menuList = [
                  MenuButton('text.cal_promotion'.tr(args: ['\n']), NovaLineIcon.credit_card_dollar, onCalculatePromotion),
                  if (isShowStock) MenuButton('text.view_stock'.tr(args: ['\n']), NovaLineIcon.warehouse_box, onCheckStock, isLoading: stockState is LoadingCheckStockStoreState),
                  MenuButton('text.filter_compare'.tr(), NovaLineIcon.move_left_right_1, onCompare),
                  if (!StringUtil.isNullOrEmpty(productState.calculatorId)) MenuButton('text.calculate'.tr(), NovaLineIcon.calculator_2, onCalculate),
                ];
              }

              return Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: menuList.map((e) {
                    return _buildButton(e);
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void onCalculatePromotion() {
    ProductState productState = BlocProvider.of<ProductBloc>(context).state;
    if (productState is ProductLoadSuccessState) {
      List<SalesItem> salesItems = []..add(SalesItem(
          seqNo: 1,
          articleId: productState.article.articleId.padLeft(18, '0'),
          unit: productState.article.unitList[0].unit,
          qty: num.parse(widget.qtyTextController.text),
        ));
      BlocProvider.of<CalculatePromotionBloc>(context).add(StartCheckPriceEvent(CalPromotionCAAppId.SCAT_POS, salesItems));
    }
  }

  void onCheckStock() {
    CheckStockStoreState checkStockStoreState = BlocProvider.of<CheckStockStoreBloc>(context).state;
    if (checkStockStoreState is GetStockStoreSuccessState) {
      DialogUtil.showCustomDialog(
        context,
        child: StockStorePanel(checkStockStoreState.stockStoreList),
      );
    }
  }

  void onCompare() {
    ProductState productState = BlocProvider.of<ProductBloc>(context).state;
    if (productState is ProductLoadSuccessState) {
      CompareProductState compareProductState = BlocProvider.of<CompareProductBloc>(context).state;
      if (compareProductState != null && compareProductState.articleList.where((e) => e.articleId == productState.article.articleId).isNullOrEmpty) {
        BlocProvider.of<CompareProductBloc>(context).add(
          AddProductCompareEvent(productState.article),
        );
      }

      BlocProvider.of<FlagCompareBloc>(context).add(
        ToggleFlagCompareEvent(),
      );
    }

    // BlocProvider.of<FlagCompareBloc>(context).add(
    //   ToggleFlagCompareEvent(),
    // );
  }

  void onCalculate() {
    ProductState state = BlocProvider.of<ProductBloc>(context).state;
    String calculatorId;
    if (state is ProductLoadSuccessState) {
      calculatorId = state.calculatorId;
    }

    DialogUtil.showCustomDialog(
      context,
      isScrollView: false,
      child: SalesGuidePage(calculatorId: calculatorId, isReadOnly: true),
    );
  }

  Widget _buildButton(MenuButton menuButton) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            width: 78,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: menuButton.isLoading
                    ? CircularProgressIndicator(color: colorBlue2_2)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            menuButton.icon,
                            color: colorBlue2_2,
                          ),
                          Text(
                            menuButton.label,
                            style: Theme.of(context).textTheme.smaller.copyWith(
                                  // fontWeight: FontWeight.bold,
                                  color: colorBlue2_2,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
              onPressed: menuButton.isLoading ? null : menuButton.action,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class SuggestTenderPanel extends StatefulWidget {
  num totalAmount;
  List<CalProRs.SuggestTender> tenderList;
  List<CalProRs.SuggestTender> otherTenderList;
  Map<MstBank, List<HirePurchasePromotion>> hirePurchaseMap;

  SuggestTenderPanel(this.totalAmount, this.tenderList, this.otherTenderList, this.hirePurchaseMap);

  _SuggestTenderPanel createState() => _SuggestTenderPanel();
}

class _SuggestTenderPanel extends State<SuggestTenderPanel> with TickerProviderStateMixin {
  TabController payCashierByTabController;

  @override
  void initState() {
    super.initState();
    payCashierByTabController = TabController(length: widget.hirePurchaseMap.isNotNE ? 2 : 1, vsync: this);
  }

  @override
  dispose() {
    payCashierByTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildDialogSuggestTender();
  }

  Widget buildDialogSuggestTender() {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;
    return Container(
      width: 800,
      height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'text.calculate.promotion'.tr(),
              style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomToggleTab(
              tabController: payCashierByTabController,
              width: widget.hirePurchaseMap.isNotNE ? 600 : 300,
              names: widget.hirePurchaseMap.isNotNE ? ['text.pay_by_credit'.tr(), 'text.hire_purchase'.tr()] : ['text.pay_by_credit'.tr()],
              selection: (value) {
                setState(() {
                  // payCashierByPageController.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.ease);
                });
              },
              selectedTextStyle: Theme.of(context).textTheme.normal.copyWith(
                    color: colorBlue7,
                    fontWeight: FontWeight.bold,
                  ),
              unSelectedTextStyle: Theme.of(context).textTheme.normal.copyWith(
                    color: colorGrey2,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _buildContent(),
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

  Widget _buildContent() {
    if (payCashierByTabController.index == 0) return _buildPayCreditCardTab();
    if (payCashierByTabController.index == 1) return _buildHireHeader(widget.hirePurchaseMap);
    return SizedBox.shrink();
  }

  Widget _buildPayCreditCardTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'text.select_credit_card_bank'.tr(),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          TenderList(
            tenderList: widget.tenderList.isNullOrEmpty ? [] : widget.tenderList,
            totalAmount: widget.totalAmount ?? 0,
            isBigFirst: true,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'text.select_other_credit'.tr(),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          TenderList(
            tenderList: widget.otherTenderList.isNullOrEmpty ? [] : widget.otherTenderList,
            totalAmount: widget.totalAmount ?? 0,
          ),
        ],
      ),
    );
  }

  Widget _buildHireHeader(Map<MstBank, List<HirePurchasePromotion>> hirePurchaseMap) {
    return HirePurchaseHeader(hirePurchaseMap);
  }
}

class HirePurchaseHeader extends StatefulWidget {
  final Map<MstBank, List<HirePurchasePromotion>> hirePurchaseMap;

  HirePurchaseHeader(this.hirePurchaseMap);

  _HirePurchaseHeader createState() => _HirePurchaseHeader();
}

class _HirePurchaseHeader extends State<HirePurchaseHeader> {
  List<MemoryImage> bankImage;

  @override
  void initState() {
    super.initState();
    bankImage = widget.hirePurchaseMap.keys.map((e) => MemoryImage(Base64Decoder().convert(e.image?.split(',')[1]))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        itemCount: widget.hirePurchaseMap.entries.length,
        itemBuilder: (context, index) {
          return _buildHire(bankImage[index], widget.hirePurchaseMap.keys.toList()[index], widget.hirePurchaseMap.values.toList()[index]);
        },
        separatorBuilder: (context, index) => SizedBox(height: 20),
        // children: widget.hirePurchaseMap.entries.map((e) {
        //   return _buildHire(e.key, e.value);
        // }).toList(),
      ),
    );
  }

  Widget _buildHire(MemoryImage bankImage, MstBank bank, List<HirePurchasePromotion> promotionList) {
    return StickyHeaderBuilder(
      builder: (BuildContext context, double stuckAmount) {
        return Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.only(left: 5, bottom: 10),
          child: Row(
            children: [
              Image.memory(
                // Base64Decoder().convert(bank.image?.split(',')[1]),
                bankImage.bytes,
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                '${bank.bankName}',
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
      content: LayoutBuilder(
        builder: (context, constraints) {
          return StaggeredGridView.extent(
            key: ValueKey<double>(constraints.maxWidth),
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: promotionList.map((e) {
              return _buildCategory(e);
            }).toList(),
            staggeredTiles: promotionList.map((e) {
              return StaggeredTile.fit(1);
            }).toList(),
          );
        },
      ),
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 5),
    //       child: Row(
    //         children: [
    //           Image.memory(
    //             Base64Decoder().convert(bank.image?.split(',')[1]),
    //             width: 40,
    //             height: 40,
    //           ),
    //           SizedBox(
    //             width: 15,
    //           ),
    //           Text(
    //             '${bank.bankName}',
    //             style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
    //           ),
    //         ],
    //       ),
    //     ),
    //     SizedBox(
    //       height: 20,
    //     ),
    //     LayoutBuilder(builder: (context, constraints) {
    //       return StaggeredGridView.extent(
    //         key: ValueKey<double>(constraints.maxWidth),
    //         physics: ClampingScrollPhysics(),
    //         shrinkWrap: true,
    //         maxCrossAxisExtent: 300,
    //         mainAxisSpacing: 4,
    //         crossAxisSpacing: 4,
    //         children: promotionList.map((e) {
    //           return _buildCategory(e);
    //         }).toList(),
    //         staggeredTiles: promotionList.map((e) {
    //           return StaggeredTile.fit(1);
    //         }).toList(),
    //       );
    //     }),
    //   ],
    // );
  }

  Widget _buildCategory(HirePurchasePromotion hirePurchasePromotion) {
    num totalAmt = hirePurchasePromotion.lstArticle.first.netItemAmt;
    if ((hirePurchasePromotion.promotion.percentDiscount ?? 0) > 0) totalAmt = MathUtil.subtract(totalAmt, MathUtil.divide(MathUtil.multiple(hirePurchasePromotion.lstArticle.first.netItemAmt, hirePurchasePromotion.promotion.percentDiscount), 100));
    bool isHaveMonth = (hirePurchasePromotion.promotion.month ?? 0) > 0;

    TextStyle priceStyle = Theme.of(context).textTheme.large;
    if (totalAmt < hirePurchasePromotion.lstArticle.first.netItemAmt) {
      priceStyle = priceStyle.copyWith(color: colorRed1, fontWeight: FontWeight.bold);
    } else {
      priceStyle = priceStyle.copyWith(color: colorBlue2, fontWeight: FontWeight.bold);
    }

    return Container(
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: Colors.white,
            ),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isHaveMonth ? hirePurchasePromotion.promotion.month.toString() : '-',
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'text.month'.tr(),
                      style: Theme.of(context).textTheme.small.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              StringUtil.getDefaultCurrencyFormat(totalAmt),
                              style: priceStyle,
                            ),
                          ),
                          Text(
                            'text.baht'.tr(),
                            style: Theme.of(context).textTheme.normal,
                          ),
                        ],
                      ),
                      Visibility(
                        visible: (hirePurchasePromotion.promotion.percentDiscount ?? 0) > 0,
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        child: Text(
                          'text.discount_percent'.tr(args: [hirePurchasePromotion.promotion.percentDiscount?.toString() ?? '']),
                          // '${isHaveMonth ? StringUtil.getDefaultCurrencyFormat(MathUtil.divide(totalAmt, hirePurchasePromotion.promotion.month)) : '-'} ${'text.baht_per_month'.tr()}',
                          // style: LanguageUtil.isTh(context) ? Theme.of(context).textTheme.normal : Theme.of(context).textTheme.small,
                          style: Theme.of(context).textTheme.normal,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class StockStorePanel extends StatefulWidget {
  final List<StockStores> stockStoreList;

  StockStorePanel(this.stockStoreList);

  @override
  _StockStorePanelState createState() => _StockStorePanelState();
}

class _StockStorePanelState extends State<StockStorePanel> {
  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;
    return Container(
      width: 800,
      height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'text.product.stock'.tr(),
              style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(child: buildStockStore()),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
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

  String getShippointName(StockStores stock) {
    List<String> dcList = ShippingPointConstants.DS_CODE_LIST.split(',');

    if (dcList.contains(stock.storeId)) {
      String trimDc = StringUtil.trimLeft(stock.storeId, 'DC');
      return stock.storeId + ' - ' + 'text.warehouse'.tr(args: [StringUtil.trimLeft(trimDc, '0')]);
    }

    return '${stock.storeId} - ${stock.storeName}';
  }

  Widget buildStockStore() {
    List<StockStores> stockStoreList = widget.stockStoreList;
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(),
      itemCount: stockStoreList.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: Text(
                StringUtil.isNullOrEmpty(stockStoreList[index].storeName) ? '${stockStoreList[index].storeId}' : getShippointName(stockStoreList[index]),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              StringUtil.getDefaultCurrencyFormat(stockStoreList[index].stockStoreArticleBos.first.availableQty),
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.normal,
            ),
            SizedBox(width: 10),
            Text(
              stockStoreList[index].stockStoreArticleBos.first.unit,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.normal,
            ),
          ],
        );
      },
    );
  }
}
