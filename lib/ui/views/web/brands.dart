import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/brand/brand_bloc.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rs.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/home_tab_sticky_builder.dart';
import 'package:flutter_store_catalog/ui/widgets/search_result_text.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'home.dart';

class BrandsPage extends StatefulWidget {
  @override
  _BrandsPageStage createState() => _BrandsPageStage();
}

class _BrandsPageStage extends State<BrandsPage> with TickerProviderStateMixin {
  AutoScrollController scrollController;
  TextEditingController searchBrandController;
  TabController tabController;
  BrandBloc brandBloc;
  String alphabetSelected = "";

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController();
    searchBrandController = TextEditingController();
    tabController = TabController(length: HomeTabStickyBuilder.tabs.length, vsync: this, initialIndex: 1);
  }

  @override
  dispose() {
    scrollController?.dispose();
    tabController?.dispose();
    brandBloc?.close();
    super.dispose();
  }

  void onBrandAlphabetSelect(String val, int index) {
    String searchText = searchBrandController.text;
    if (!StringUtil.isNullOrEmpty(searchText)) {
      searchBrandController.clear();
      brandBloc.add(
        SearchBrandEvent(''),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 500),
      );
    });

    setState(() {
      alphabetSelected = val;
    });
  }

  void onBrandSelect(BrandList brand) {
    Navigator.pushNamed(context, WebRoutePaths.Brand, arguments: {'brand': brand});
  }

  void onDestinationSelected(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false, arguments: {'isGoToCategoryTab': true});
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Rooms, (route) => false);
    }
  }

  void onSearchBrand() {
    FocusScope.of(context).unfocus();
    brandBloc.add(
      SearchBrandEvent(searchBrandController.text),
    );
    setState(() {
      alphabetSelected = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => brandBloc = BrandBloc(BlocProvider.of<ApplicationBloc>(context))
        ..add(
          SearchBrandEvent(''),
        ),
      child: BlocListener(
        bloc: brandBloc,
        condition: (prevState, currentState) {
          if (prevState is LoadingBrandState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) async {
          if (state is ErrorBrandState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is LoadingBrandState) {
            DialogUtil.showLoadingDialog(context);
          }
        },
        child: CommonLayout(
          bodyBackgroundColor: Colors.white,
          body: Scaffold(
            body: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: [
                  HomeTabStickyBuilder(
                    scrollController: scrollController,
                    tabController: tabController,
                    onDestinationSelected: onDestinationSelected,
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBrandPanel(searchBrandController: searchBrandController, onSearch: onSearchBrand),
                        buildBrandAlphabet(1),
                        buildBrandAlphabet(2),
                      ],
                    ),
                    body: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: buildBrandListPanel(),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
          ),
        ),
      ),
    );
  }

  Widget buildBrandAlphabet(int rowCase) {
    return BlocBuilder<BrandBloc, BrandState>(
      condition: (previous, current) => current is BrandLoadSuccessState,
      builder: (context, state) {
        if (state is BrandLoadSuccessState) {
          TextStyle styleUnSelect = Theme.of(context).textTheme.large.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              );

          TextStyle styleSelect = Theme.of(context).textTheme.large.copyWith(
                color: colorBlue7,
                fontWeight: FontWeight.bold,
              );
          return RichText(
            text: TextSpan(
              children: (rowCase == 1 ? state.mapBrandSelectionFirstRow.keys : state.mapBrandSelectionSecondRow.keys)
                  .map(
                    (e) => WidgetSpan(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6, left: 6),
                          child: Text(
                            e,
                            style: alphabetSelected == e ? styleSelect : styleUnSelect,
                          ),
                        ),
                        onTap: () {
                          onBrandAlphabetSelect(e, state.brandSelections.indexOf(e));
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget buildBrandListPanel() {
    return BlocBuilder<BrandBloc, BrandState>(
      condition: (previous, current) => current is BrandLoadSuccessState,
      builder: (context, state) {
        if (state is BrandLoadSuccessState) {
          if (state.mapBrandResult == null || state.mapBrandResult.length == 0)
            return SearchResultText(
              result: state.mapBrandResult.length,
              searchText: searchBrandController.text,
            );

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.mapBrandResult.length,
            itemBuilder: (BuildContext context, int index) {
              String brandGroup = state.mapBrandResult.keys.elementAt(index);
              return buildBrandList(context: context, brandGroup: brandGroup, brandList: state.mapBrandResult[brandGroup], index: state.brandSelections.indexOf(brandGroup));
            },
          );
        }
        return Container();
      },
    );
  }

  Widget buildBrandList({BuildContext context, List<BrandList> brandList, String brandGroup, int index}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: scrollController,
      index: index,
      child: Container(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brandGroup,
              style: Theme.of(context).textTheme.xlarger.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            StaggeredGridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              shrinkWrap: true,
              children: brandList.map((e) => _buildBrandColumn(e)).toList(),
              staggeredTiles: brandList.map((e) => StaggeredTile.fit(1)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandColumn(BrandList brand) {
    return InkWell(
      child: Text(
        brand.brandId,
        style: Theme.of(context).textTheme.normal,
      ),
      onTap: () {
        onBrandSelect(brand);
      },
    );
  }
}

class SearchBrandPanel extends StatefulWidget {
  final TextEditingController searchBrandController;
  final Function onSearch;

  const SearchBrandPanel({Key key, this.searchBrandController, this.onSearch}) : super(key: key);

  @override
  _SearchBrandPanelState createState() => _SearchBrandPanelState();
}

class _SearchBrandPanelState extends State<SearchBrandPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSearchBrandBox();
  }

  Widget buildSearchBrandBox() {
    return Container(
      width: 500,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: VirtualKeyboardWrapper(
                textController: widget.searchBrandController,
                maxLength: 50,
                onKeyPress: (key) {
                  if (key.action == VirtualKeyboardKeyAction.Return) {
                    widget.onSearch();
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
                      suffixIcon: widget.searchBrandController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                widget.searchBrandController.clear();
                                widget.onSearch();
                              },
                              icon: Icon(Icons.clear),
                            )
                          : null,
                      hintText: 'text.search_brand'.tr(),
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
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: colorAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
                onPressed: () {
                  widget.onSearch();
                },
                child: Text('text.search_brand'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
