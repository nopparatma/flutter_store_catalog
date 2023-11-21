import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/compare_product/compare_product_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_compare/flag_compare_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_list/search_product_list_bloc.dart';
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_filter_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/compare_product.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/header_filter_list.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_solid_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/product_list.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/search_result_text.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductsPage extends StatefulWidget {
  final MCH2List mch2;
  final MCH1CategoryList mch1;
  final String searchText;
  final String brandId;
  final CalculatorRs calculatorRs;

  const ProductsPage({Key key, this.mch2, this.mch1, this.searchText, this.brandId, this.calculatorRs}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  ScrollController scrollController;
  TextEditingController searchTextController;
  SearchProductListBloc searchProductListBloc;
  GetArticleRq getArticleRq = GetArticleRq();
  List<MCHList> searchTermList = [];
  List<GetArticleRqBrandList> brandList = [];
  List<GetArticleRqFeatureList> featureList = [];
  bool isQuestionnaire = false;

  void onSearch() {
    String searchText = searchTextController.text;
    if (searchText.isEmpty || searchText.length < 2) {
      return;
    }
    FocusScope.of(context).unfocus();
    searchProductListBloc.add(
      SearchMchProductItemEvent(
        GetArticleRq(
          desc: searchText,
          pageSize: SEARCH_PRODUCT_PAGE_SIZE,
        ),
        null,
        null,
      ),
    );
  }

  void onCloseQuestionnaire() {
    Navigator.of(context).pop(true);
  }

  void onPressedSalesGuide(Grouping groupSalesGuideItem) {
    Navigator.of(context).pushNamed(WebRoutePaths.SalesGuide, arguments: {
      'knowledgeIdList': groupSalesGuideItem.knowledgeIdList,
      'calculatorId': groupSalesGuideItem.calculator,
    });
  }

  @override
  void initState() {
    super.initState();
    searchTextController = new TextEditingController();
    searchTextController.value = searchTextController.value.copyWith(
      text: widget.searchText ?? '',
      selection: TextSelection.fromPosition(TextPosition(offset: searchTextController.text.length)),
      composing: TextRange.empty,
    );
    scrollController = new ScrollController();

    if (widget.mch1 == null && widget.mch2 != null) {
      for (var mch1 in widget.mch2.mCH1CategoryList) {
        for (var item in mch1.searchTermList) {
          searchTermList.add(MCHList(item.mCHId));
        }
      }
    } else if (widget.mch1 != null) {
      for (var item in widget.mch1.searchTermList) {
        searchTermList.add(MCHList(item.mCHId));
      }
    }

    if (widget.brandId != null) {
      brandList.add(GetArticleRqBrandList(widget.brandId));
    }

    isQuestionnaire = false;
    if (widget.calculatorRs != null) {
      featureList.add(GetArticleRqFeatureList(widget.calculatorRs.featureCode, featureDesc: (widget.calculatorRs.resultCalculator ?? 0).toString()));
      widget.calculatorRs.mchs?.forEach((element) {
        searchTermList.add(MCHList(element));
      });
      isQuestionnaire = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => searchProductListBloc = SearchProductListBloc(BlocProvider.of<ApplicationBloc>(context))
            ..add(
              SearchMchProductItemEvent(
                GetArticleRq(
                  mCHList: searchTermList,
                  desc: widget.searchText,
                  brandList: brandList,
                  featureList: featureList,
                  pageSize: SEARCH_PRODUCT_PAGE_SIZE,
                ),
                null,
                null,
              ),
            ),
        ),
      ],
      child: CommonLayout(
        isShowBack: true,
        body: Scaffold(
          body: Container(
            child: Stack(
              children: [
                BlocConsumer<SearchProductListBloc, SearchProductListState>(
                  listenWhen: (prevState, currentState) {
                    if (prevState is LoadingProductItemState) {
                      DialogUtil.hideLoadingDialog(context);
                    }
                    return true;
                  },
                  listener: (context, state) async {
                    if (state is ErrorMchProductItemState) {
                      DialogUtil.showErrorDialog(context, state.error);
                    } else if (state is LoadingProductItemState) {
                      DialogUtil.showLoadingDialog(context);
                    }
                  },
                  buildWhen: (previous, current) {
                    return (current is InitialSearchProductListState || current is SearchMchProductItemState || current is SearchMchProductItemFilterState);
                  },
                  builder: (context, state) {
                    GetArticleRs getArticleRs = GetArticleRs();
                    GetArticleRq getArticleRq;
                    GetArticleFilterRs getArticleFilterRs;
                    GetProductGuideRs getProductGuideRs;

                    if (state is InitialSearchProductListState) {
                      return SizedBox.shrink();
                    }

                    if (state is SearchMchProductItemState) {
                      getArticleRq = state.getArticleRq;
                      getArticleRs = state.getArticleRs;
                      getArticleFilterRs = state.getArticleFilterRs;
                      getProductGuideRs = state.getProductGuideRs;
                    }

                    if (state is SearchMchProductItemFilterState) {
                      getArticleRq = state.getArticleRq;
                      getArticleRs = state.getArticleRs;
                      getArticleFilterRs = state.getArticleFilterRs;
                      getProductGuideRs = state.getProductGuideRs;
                    }

                    return Scrollbar(
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverStickyHeader(
                            sticky: true,
                            header: buildMainHeader(getArticleRs, getArticleFilterRs, getProductGuideRs),
                            sliver: ((state is SearchMchProductItemState || state is SearchMchProductItemFilterState) && widget.mch2 != null) && (getArticleRs == null || getArticleRs.totalSize == 0)
                                ? SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                                      child: SearchResultText(result: 0, searchText: ''),
                                    ),
                                  )
                                : ProductList(getArticleRq: getArticleRq, getArticleRs: getArticleRs),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
          ),
          floatingActionButton: BlocBuilder<FlagCompareBloc, FlagCompareState>(
            builder: (context, state) {
              if (state.isCompared) {
                return CustomBackToTopButton(scrollController: scrollController, marginBottom: 115);
              }
              return CustomBackToTopButton(scrollController: scrollController);
            },
          ),
        ),
      ),
    );
  }

  Widget buildMainHeader(GetArticleRs getArticleRs, GetArticleFilterRs articleFilterRs, GetProductGuideRs getProductGuideRs) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderByMode(getArticleRs),
            SizedBox(height: 10),
            if (getArticleRs.totalSize > 0 || articleFilterRs != null)
              HeaderFilterList(
                getArticleFilterRs: articleFilterRs,
                mch2: widget.mch2,
                mch1: widget.mch1,
                brandId: widget.brandId,
                calculatorRs: widget.calculatorRs,
              ),
            if (!isQuestionnaire) buildSalesGuideButton(getProductGuideRs),
            if (widget.mch1 != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  LanguageUtil.isTh(context) ? widget.mch1.mCH1NameTH : widget.mch1.mCH1NameEN,
                  style: Theme.of(context).textTheme.larger.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSalesGuideButton(GetProductGuideRs getProductGuideRs) {
    if (getProductGuideRs == null || getProductGuideRs?.grouping == null || getProductGuideRs?.grouping?.length == 0) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 70,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: getProductGuideRs.grouping.length,
          itemBuilder: (context, index) => buildSalesGuideItemButton(getProductGuideRs.grouping[index]),
        ),
      ),
    );
  }

  Widget buildSalesGuideItemButton(Grouping groupSalesGuideItem) {
    bool isKnowledge = groupSalesGuideItem.knowledgeIdList != null && groupSalesGuideItem.knowledgeIdList.length > 0;
    bool isCalculator = !StringUtil.isNullOrEmpty(groupSalesGuideItem.calculator);

    IconData icon = NovaSolidIcon.magic_wand_2;
    if (isKnowledge && isCalculator) {
      icon = NovaSolidIcon.magic_wand_2;
    } else if (isCalculator) {
      icon = NovaSolidIcon.calculator_1;
    } else if (isKnowledge) {
      icon = NovaSolidIcon.user_lightbulb_2;
    }

    return Container(
      width: 250,
      padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(width: 1, color: colorBlue7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: colorBlue7),
                    Text(''),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageUtil.isTh(context) ? groupSalesGuideItem.groupNameTh : groupSalesGuideItem.groupNameEn,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorBlue7),
                    ),
                    Text(
                      '${'text.see_detail'.tr()} >',
                      style: Theme.of(context).textTheme.small.copyWith(fontWeight: FontWeight.normal, decoration: TextDecoration.underline, color: colorDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onPressed: () => onPressedSalesGuide(groupSalesGuideItem),
      ),
    );
  }

  Widget buildHeaderByMode(GetArticleRs getArticleRs) {
    if (isQuestionnaire) return buildTextSearch(getArticleRs, isQuestionnaire: true);

    if (widget.mch2 == null) return buildTextSearch(getArticleRs);

    return Text(
      LanguageUtil.isTh(context) ? widget.mch2.mCH2NameTH : widget.mch2.mCH2NameEN,
      style: Theme.of(context).textTheme.larger.copyWith(
            fontWeight: FontWeight.bold,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildTextSearch(GetArticleRs getArticleRs, {bool isQuestionnaire = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 300,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: isQuestionnaire
                        ? buildQuestionnaireHeader()
                        : VirtualKeyboardWrapper(
                            textController: searchTextController,
                            maxLength: 50,
                            onKeyPress: (key) {
                              if (key.action == VirtualKeyboardKeyAction.Return) {
                                onSearch();
                              }
                            },
                            builder: (textEditingController, focusNode, inputFormatters) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                inputFormatters: inputFormatters,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: searchTextController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            searchTextController.clear();
                                          },
                                          icon: Icon(Icons.clear),
                                        )
                                      : null,
                                  hintText: '${'text.search_product'.tr()}...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: colorBlue3,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (!isQuestionnaire)
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: colorAccent,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                        ),
                        onPressed: () {
                          onSearch();
                        },
                        child: Text('text.search_product'.tr()),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!StringUtil.isNullOrEmpty(searchTextController.text)) SearchResultText(result: getArticleRs.totalSize, searchText: searchTextController.text),
      ],
    );
  }

  Widget buildQuestionnaireHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorBlue5,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.search, color: colorBlue2_2),
                ),
                Expanded(
                  child: Text(
                    'text.suggest_product_from_questionnaire'.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold, color: colorBlue2_2),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            iconSize: 35,
            onPressed: () {
              onCloseQuestionnaire();
            },
            icon: Icon(NovaLineIcon.remove_square_1, color: colorBlue7),
          ),
        ],
      ),
    );
  }
}
