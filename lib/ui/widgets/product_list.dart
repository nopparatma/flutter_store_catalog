import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_store_catalog/core/blocs/compare_product/compare_product_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_compare/flag_compare_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_list/search_product_list_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:easy_localization/easy_localization.dart';

import '../router.dart';
import 'custom_checkbox.dart';
import 'more_discount.dart';

const num SEARCH_PRODUCT_PAGE_SIZE = 20;

class ProductList extends StatefulWidget {
  final GetArticleRq getArticleRq;
  final GetArticleRs getArticleRs;

  const ProductList({Key key, this.getArticleRq, this.getArticleRs}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  PagewiseLoadController pageLoadController;

  @override
  void initState() {
    super.initState();
    pageLoadController = PagewiseLoadController(
      pageSize: SEARCH_PRODUCT_PAGE_SIZE,
      pageFuture: (pageIndex) {
        // print('pageFuture $pageIndex');
        return getArticlePaging(pageIndex, SEARCH_PRODUCT_PAGE_SIZE, widget.getArticleRq, widget.getArticleRs);
      },
    );
  }

  static const double maxWidthProductBox = 300.0;
  static const double heightCompareProductBox = 440.0;
  static const double heightProductBox = 410.0;

  double getAspectRatioGridView(bool isCompareMode) {
    var maxWidth = maxWidthProductBox;
    var width = MediaQuery.of(context).size.width - AppBar().preferredSize.height; // - navigator size bar
    var widthSpacer = ((width ~/ maxWidth) + 1) * 12;

    var widthEx = width - widthSpacer;
    var columns = (widthEx ~/ maxWidth) + 1;
    var columnWidth = widthEx / columns;
    // height of one grid item
    var aspectRatio = columnWidth / (isCompareMode ? heightCompareProductBox : heightProductBox);

    // print('width $width');
    // print('widthSpacer $widthSpacer');
    // print('widthEx $widthEx');
    // print('column $columns');
    // print('columnWidth $columnWidth');
    // print('aspectRatio $aspectRatio');

    return aspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.getArticleRs == null || widget.getArticleRs.articleList == null || widget.getArticleRs.articleList.isEmpty) {
      return SliverToBoxAdapter();
    }

    return BlocListener<SearchProductListBloc, SearchProductListState>(
      listener: (context, state) {
        if (state is SearchMchProductItemState || state is SearchMchProductItemFilterState) {
          pageLoadController.reset();
        }
      },
      child: BlocBuilder<FlagCompareBloc, FlagCompareState>(
        builder: (context, state) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: PagewiseSliverGrid.extent(
              pageLoadController: pageLoadController,
              maxCrossAxisExtent: maxWidthProductBox,
              childAspectRatio: getAspectRatioGridView(state.isCompared),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemBuilder: (context, entry, index) {
                //print('itemBuilder $index');
                return ProductItem(article: entry, indexItem: index, getArticleRs: widget.getArticleRs);
              },
              loadingBuilder: (context) {
                return Container(
                  height: 64,
                  width: 64,
                  child: ColoredCircularProgressIndicator(strokeWidth: 8),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<ArticleList>> getArticlePaging(int pageIndex, int pageSize, GetArticleRq getArticleRq, GetArticleRs firstGetArticleRs) async {
    if (pageIndex == 0) {
      return firstGetArticleRs.articleList;
    }

    getArticleRq.pageSize = pageSize;
    getArticleRq.startRow = pageIndex * pageSize;

    GetArticleRs getArticleRs = await getIt<CategoryService>().getArticlePaging(getArticleRq);

    return getArticleRs.articleList;
  }
}

class ProductItem extends StatefulWidget {
  final ArticleList article;
  final int indexItem;
  final GetArticleRs getArticleRs;

  ProductItem({this.article, this.indexItem, this.getArticleRs});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return buildProductCard(
      widget.article,
    );
  }

  Widget buildCheckboxCompare() {
    return BlocBuilder<FlagCompareBloc, FlagCompareState>(
      builder: (context, state) {
        if (!state.isCompared) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Row(
            children: [
              BlocBuilder<CompareProductBloc, CompareProductState>(
                builder: (context, state) {
                  return CustomCheckbox(
                    value: state.articleList.where((e) => e.articleId == widget.article.articleId).isNotEmpty,
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
                          AddProductCompareEvent(widget.article),
                        );
                      } else {
                        BlocProvider.of<CompareProductBloc>(context).add(
                          RemoveProductCompareEvent(state.articleList.indexWhere((e) => e.articleId == widget.article.articleId)),
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
      },
    );
  }

  Widget buildProductCard(ArticleList article) {
    bool isHaveSpecialPrice = article.unitList[0].promotionPrice != null && article.unitList[0].promotionPrice > 0 ? true : false;
    String normalPrice = StringUtil.getDefaultCurrencyFormat(article.unitList[0].normalPrice);
    String promotionPrice = StringUtil.getDefaultCurrencyFormat(article.unitList[0].promotionPrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCheckboxCompare(),
        InkWell(
          child: Container(
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: Text(
                      article.brand,
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: colorBlue3,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  buildProductDetail(article, isHaveSpecialPrice, normalPrice, promotionPrice),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(WebRoutePaths.Product, arguments: {'article': article});
          },
        ),
      ],
    );
  }

  Widget buildProductDetail(ArticleList article, bool isHaveSpecialPrice, String normalPrice, String promotionPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(WebRoutePaths.Product, arguments: {'article': article});
          },
          child: Container(
            height: 150,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/non_article_image.png',
              image: ImageUtil.getFullURL(article.imageCover),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/non_article_image.png');
              },
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  height: 40,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      if ('Y' == article.unitList[0].flagGetFreeGift)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/${context.locale.toString()}/freegift.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      if (article.isFreeInstall)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/${context.locale.toString()}/freeinst.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
        Container(
          height: 40,
          child: (article.unitList[0].discountAmount > 0)
              ? FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: MoreDiscount(
                      discountPrice: article.unitList[0].discountAmount,
                    ),
                  ),
                )
              : Container(),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
