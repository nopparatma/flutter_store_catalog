import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/compare_product/compare_product_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_compare/flag_compare_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/product/product_bloc.dart';
import 'package:flutter_store_catalog/core/models/ecat/compare_article_attirbute_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_compare/search_product_compare_bloc.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';

import '../router.dart';
import 'custom_close_dialog_button.dart';
import 'dialog_check_list.dart';

class CompareProduct extends StatefulWidget {
  final List<ArticleList> articleList;

  CompareProduct(this.articleList);

  @override
  _CompareProduct createState() => _CompareProduct();
}

class _CompareProduct extends State<CompareProduct> {
  static const int MAX_COMPARE_ITEM_COUNT = 4;

  void onCancel() {
    BlocProvider.of<FlagCompareBloc>(context).add(
      ToggleFlagCompareEvent(),
    );
    BlocProvider.of<CompareProductBloc>(context).add(
      RemoveAllProductCompareEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBottomPanel();
  }

  Widget buildBottomPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 110,
        color: Colors.white.withOpacity(0.9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'text.filter_compare'.tr(),
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${widget.articleList.length} ${'text.in'.tr()} $MAX_COMPARE_ITEM_COUNT ${'text.product'.tr()}',
                            style: Theme.of(context).textTheme.small.copyWith(
                                  color: colorGrey1,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 410,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: MAX_COMPARE_ITEM_COUNT,
                              itemBuilder: (context, index) {
                                if (widget.articleList.length >= index + 1) {
                                  return buildDialogContent(index);
                                } else {
                                  return buildEmptyDialog();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: colorBlue7,
                          onPrimary: Colors.white,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: widget.articleList.length < 2
                            ? null
                            : () {
                                DialogUtil.showCustomDialog(
                                  context,
                                  child: PopupProductCompared(articleList: widget.articleList),
                                  isShowCloseButton: true,
                                  backgroundColor: colorGrey4,
                                );
                              },
                        child: Text(
                          'text.compare_result'.tr(),
                          style: Theme.of(context).textTheme.normal.copyWith(
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: CustomCloseDialogButton(
                  isInkStyle: false,
                  onTap: () {
                    onCancel();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyDialog() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 2,
        bottom: 5,
      ),
      child: Container(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.0, right: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1),
                    blurRadius: 4.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDialogContent(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 2,
        bottom: 5,
      ),
      child: Container(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 12.0, right: 8.0),
              decoration: BoxDecoration(
                border: new Border.all(
                  color: colorBlue7,
                  width: 2,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/non_article_image.png',
                image: ImageUtil.getFullURL(widget.articleList[index].imageCover ?? (widget.articleList[index].imageList.isNotNE ? widget.articleList[index].imageList.first.imageSmall : null)),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/non_article_image.png');
                },
              ),
            ),
            Positioned(
              right: 1,
              top: 1,
              child: InkWell(
                onTap: () {
                  BlocProvider.of<CompareProductBloc>(context).add(
                    RemoveProductCompareEvent(widget.articleList.indexWhere((e) => e.articleId == widget.articleList[index].articleId)),
                  );
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: colorBlue7,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        color: colorBlue7,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopupProductCompared extends StatefulWidget {
  final List<ArticleList> articleList;

  const PopupProductCompared({Key key, this.articleList}) : super(key: key);

  @override
  _PopupProductComparedState createState() => _PopupProductComparedState();
}

class _PopupProductComparedState extends State<PopupProductCompared> {
  CompareArticleAttributeRs compareArticleAttributeRs = CompareArticleAttributeRs();
  List<ArticleList> articleDetailList = [];
  List<String> mappingIdList = [];
  double popupWidth;
  double popupHeight;

  Future<void> onAddToCart(ArticleList article, String mappingId) async {
    bool isFoundArticleCheckList = BlocProvider.of<BasketBloc>(context).state.isFoundArticleCheckList(article);
    bool isMappingCheckList = StringUtil.isNullOrEmpty(mappingId) ? false : true;
    if (isMappingCheckList && !isFoundArticleCheckList) {
      bool isConfirmMappingCheckList;
      if (article?.isFreeInstall ?? false) {
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
            'article': article,
          },
        );

        if (checkListData == null) return; // skip back button

        BlocProvider.of<BasketBloc>(context).add(
          BasketAddItemEvent(BasketItem(article, 1, checkListData: checkListData), false),
        );
        return;
      }
    }

    // not mapping or won't check list
    BlocProvider.of<BasketBloc>(context).add(
      BasketAddItemEvent(BasketItem(article, 1), false),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    popupWidth = MediaQuery.of(context).size.width * 0.9;
    popupHeight = MediaQuery.of(context).size.height * 0.75;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => ProductCompareSearchBloc(BlocProvider.of<ApplicationBloc>(context))
            ..add(
              SearchProductCompareEvent(widget.articleList),
            ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductCompareSearchBloc, ProductCompareSearchState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingProductCompareSearchState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is ErrorProductCompareSearchState) {
                DialogUtil.showErrorDialog(context, state.error);
              } else if (state is LoadingProductCompareSearchState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is SearchProductCompareState) {
                compareArticleAttributeRs = state.compareArticleAttributeRs;
                articleDetailList = state.articleList;
                mappingIdList = state.mappingIdList;
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
        ],
        child: BlocBuilder<ProductCompareSearchBloc, ProductCompareSearchState>(
          builder: (context, state) {
            if (state is SearchProductCompareState && compareArticleAttributeRs.compareAttributeList.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextHeader(),
                    Container(
                      width: popupWidth,
                      height: popupHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HorizontalDataTable(
                        isFixedHeader: true,
                        headerWidgets: [
                          Container(
                            width: 300,
                            height: 300,
                            color: colorGrey4,
                          ),
                          Expanded(
                            child: Container(
                              width: 280.0 * (articleDetailList.length),
                              height: 300,
                              color: colorGrey4,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                children: articleDetailList.map((e) => buildProductDetail(e, mappingIdList[articleDetailList.indexOf(e)])).toList(),
                              ),
                            ),
                          ),
                        ],
                        leftHandSideColumnWidth: 300,
                        rightHandSideColumnWidth: 280.0 * (articleDetailList.length),
                        itemCount: compareArticleAttributeRs.compareAttributeList.length,
                        leftSideItemBuilder: buildAttributeName,
                        rightSideItemBuilder: buildAttributeData,
                        leftHandSideColBackgroundColor: colorGrey4,
                        rightHandSideColBackgroundColor: colorGrey4,
                        rowSeparatorWidget: const Divider(
                          color: colorGrey3,
                          height: 1.0,
                          thickness: 0.0,
                        ),
                        verticalScrollbarStyle: const ScrollbarStyle(
                          isAlwaysShown: true,
                          thickness: 4.0,
                          radius: Radius.circular(5.0),
                        ),
                        horizontalScrollbarStyle: const ScrollbarStyle(
                          isAlwaysShown: true,
                          thickness: 4.0,
                          radius: Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextHeader(),
                  Container(
                    width: popupWidth,
                    height: popupHeight,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          'text.compare_result_table'.tr(),
          style: Theme.of(context).textTheme.larger.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget buildProductDetail(ArticleList article, String mappingId) {
    bool isHaveSpecialPrice = article.unitList[0].promotionPrice != null && article.unitList[0].promotionPrice > 0 ? true : false;
    String normalPrice = StringUtil.getDefaultCurrencyFormat(article.unitList[0].normalPrice);
    String promotionPrice = StringUtil.getDefaultCurrencyFormat(article.unitList[0].promotionPrice);

    return Container(
      width: 280,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.fitWidth,
                placeholder: 'assets/images/non_article_image.png',
                image: ImageUtil.getFullURL(article.imageList.isNotNE ? article.imageList[0].imageLarge : ''),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/non_article_image.png');
                },
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              StringUtil.isNotEmpty(article.articleFullNameTH)
                  ? LanguageUtil.isTh(context)
                      ? article.articleFullNameTH
                      : article.articleFullNameEN
                  : LanguageUtil.isTh(context)
                      ? article.articleNameTH
                      : article.articleNameEN,
              style: Theme.of(context).textTheme.normal.copyWith(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'text.sku.colon'.tr(args: ['${StringUtil.trimLeftZero(article.articleId)}']),
              style: Theme.of(context).textTheme.small.copyWith(
                    color: colorGrey1,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          if (isHaveSpecialPrice)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  normalPrice,
                  style: Theme.of(context).textTheme.normal.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    promotionPrice,
                    style: Theme.of(context).textTheme.large.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorRed1,
                        ),
                  ),
                ),
                Text(
                  'text.baht'.tr(),
                  style: Theme.of(context).textTheme.normal,
                ),
              ],
            ),
          if (!isHaveSpecialPrice)
            Text(
              '$normalPrice ${'text.baht'.tr()}',
              style: Theme.of(context).textTheme.large,
              textAlign: TextAlign.center,
            ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorBlue7,
                      onPrimary: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () {
                      onAddToCart(article, mappingId);
                    },
                    child: Text(
                      'text.add_to_cart'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAttributeName(BuildContext context, int index) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          LanguageUtil.isTh(context) ? '${compareArticleAttributeRs.compareAttributeList[index].attributeNameTH}' : '${compareArticleAttributeRs.compareAttributeList[index].attributeNameEN}',
          style: Theme.of(context).textTheme.normal.copyWith(
                fontWeight: FontWeight.bold,
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget buildAttributeData(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: articleDetailList.length,
              itemBuilder: (context, i) {
                return Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LanguageUtil.isTh(context) ? '${compareArticleAttributeRs.compareAttributeList[index].attributeList[i].attributeDataTH}' : '${compareArticleAttributeRs.compareAttributeList[index].attributeList[i].attributeDataEN}',
                      style: Theme.of(context).textTheme.normal,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
