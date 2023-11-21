import 'dart:core';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/category/category_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/home_tab_sticky_builder.dart';
import 'package:flutter_store_catalog/ui/widgets/search_product_panel.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class HomePage extends StatefulWidget {
  final bool isGoToCategoryTab;

  const HomePage({Key key, this.isGoToCategoryTab = false}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<CategoryModel> categoryStyles = [
  CategoryModel(Color(0xFFFFB030), 2, 1),
  CategoryModel(Color(0xFF787878), 1, 1),
  CategoryModel(Color(0xFF3B8EEE), 1, 2),
  CategoryModel(Color(0xFF97C45D), 1, 1),
  CategoryModel(Color(0xFFFFA88D), 1, 1),
  CategoryModel(Color(0xFF2882A4), 1, 1),
  CategoryModel(Color(0xFF2882A4), 1, 1),
  CategoryModel(Color(0xFF787878), 2, 1),
  CategoryModel(Color(0xFF97C45D), 1, 1),
  CategoryModel(Color(0xFF3B8EEE), 1, 2),
  CategoryModel(Color(0xFF2882A4), 1, 1),
  CategoryModel(Color(0xFFFFB030), 2, 1),
  CategoryModel(Color(0xFF97C45D), 1, 1),
  CategoryModel(Color(0xFFFFA88D), 1, 1),
  CategoryModel(Color(0xFF787878), 1, 1),
];

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const int autoScrollTabIndex = 0;
  AutoScrollController scrollController;
  int menuIndex;
  TabController tabController;
  Orientation orientation;
  CategoryBloc categoryBloc;

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController();
    menuIndex = 0;
    tabController = TabController(length: HomeTabStickyBuilder.tabs.length, vsync: this);

    if (widget.isGoToCategoryTab) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollController.scrollToIndex(
          autoScrollTabIndex,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 500),
        );
      });
    }
  }

  @override
  dispose() {
    scrollController.dispose();
    tabController.dispose();
    categoryBloc?.close();
    super.dispose();
  }

  void onDestinationSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tabController.animateTo(index);
      scrollController.scrollToIndex(
        autoScrollTabIndex,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 500),
      );
    });

    if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Brands, (route) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Rooms, (route) => false);
    }
  }

  Widget buildTabBody(int index) {
    if (index == 0) {
      return buildCategoryBody();
    }
    return Container();
  }

  Widget buildCategoryBody() {
    return BlocProvider(
      create: (ctx) => categoryBloc = CategoryBloc(BlocProvider.of<ApplicationBloc>(context))..add(SearchCategoryEvent()),
      child: BlocListener(
        bloc: categoryBloc,
        listener: (context, state) async {
          if (state is ErrorCategoryState) {
            DialogUtil.showErrorDialog(context, state.error);
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          bloc: categoryBloc,
          builder: (context, state) {
            if (state is LoadingCategoryState) {
              return Center(
                  child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 64,
                  width: 64,
                  child: ColoredCircularProgressIndicator(strokeWidth: 8),
                ),
              ));
            } else if (state is CategoryLoadSuccessState) {
              GetCategoryRs getCategoryRs = BlocProvider.of<ApplicationBloc>(context).state.getCategoryRs;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StaggeredGridView.count(
                  key: ValueKey<int>(orientation == Orientation.portrait ? 3 : 4),
                  crossAxisCount: orientation == Orientation.portrait ? 3 : 4,
                  shrinkWrap: true,
                  primary: false,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  padding: const EdgeInsets.all(4),
                  children: getCategoryRs?.mCH3List?.map((e) {
                        CategoryModel style = categoryStyles[getCategoryRs.mCH3List.indexOf(e) % categoryStyles.length];
                        return CategoryTile(style.color, e, style.columnCellCount > style.rowCellCount);
                      })?.toList() ??
                      [],
                  staggeredTiles: getCategoryRs?.mCH3List?.map((e) {
                        CategoryModel style = categoryStyles[getCategoryRs.mCH3List.indexOf(e) % categoryStyles.length];
                        return StaggeredTile.count(style.columnCellCount, style.rowCellCount.toDouble());
                      })?.toList() ??
                      [],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      this.orientation = orientation;
      return CommonLayout(
        onDestinationSelected: onDestinationSelected,
        bodyBackgroundColor: Colors.white,
        body: Scaffold(
          body: Scrollbar(
            child: ListView(
              controller: scrollController,
              children: [
                buildHomeSearchPanel(),
                AutoScrollTag(
                  key: ValueKey(autoScrollTabIndex),
                  controller: scrollController,
                  index: autoScrollTabIndex,
                  child: HomeTabStickyBuilder(
                    scrollController: scrollController,
                    tabController: tabController,
                    onDestinationSelected: onDestinationSelected,
                    body: buildTabBody(menuIndex),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
        ),
      );
    });
  }

  Widget buildHomeSearchPanel() {
    return Stack(
      children: [
        Positioned.fill(
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: 'assets/images/banner_main_catalog.jpg',
            image: getIt<CategoryService>().getImageByKeyUrl('SEARCH_BANNER'),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/banner_main_catalog.jpg',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 150),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'text.home_search_text1'.tr(namedArgs: {"num": StringUtil.getDefaultCurrencyFormat(100000)}),
                  style: Theme.of(context).textTheme.xxlarger.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'text.home_search_text2'.tr(),
                  style: Theme.of(context).textTheme.xxlarger.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                SearchProductPanel(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile(this.backgroundColor, this.mch3, this.isColorHorizontalAlignment);

  final Color backgroundColor;
  final MCH3List mch3;
  final bool isColorHorizontalAlignment;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeInImage.assetNetwork(
              // fit: BoxFit.fill,
              fit: BoxFit.cover,
              placeholder: 'assets/images/non_article_image.png',
              image: ImageUtil.getFullURL(mch3.mCH3ImgUrl),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/non_article_image.png');
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    backgroundColor.withOpacity(0.9),
                    backgroundColor.withOpacity(0.1),
                  ],
                  begin: isColorHorizontalAlignment ? Alignment.centerLeft : Alignment.topCenter,
                  end: isColorHorizontalAlignment ? Alignment.centerRight : Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  LanguageUtil.isTh(context) ? mch3.mCH3NameTH : mch3.mCH3NameEN,
                  style: Theme.of(context).textTheme.larger.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(WebRoutePaths.Category, arguments: {'mch3': mch3, 'backgroundColor': backgroundColor});
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryModel {
  final Color color;
  final int columnCellCount;
  final int rowCellCount;

  const CategoryModel(this.color, this.columnCellCount, this.rowCellCount);
}
