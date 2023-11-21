import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_brand_category/search_brand_category_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_category_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_vertical_divider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_store_catalog/ui/widgets/category_list.dart';

class BrandPage extends StatefulWidget {
  final BrandList brand;

  const BrandPage({Key key, this.brand}) : super(key: key);

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  AutoScrollController scrollController;
  int selectedCategoryIndex = 0;
  GetBrandCategoryRs getBrandCategoryRs;

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController();
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onCategorySelect(int index) {
    setState(() => selectedCategoryIndex = index);
    scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => SearchBrandCategoryBloc(BlocProvider.of<ApplicationBloc>(context))
            ..add(
              SearchCategoryEvent(GetBrandCategoryRq(brandId: widget.brand.brandId), null),
            ),
        )
      ],
      child: CommonLayout(
        isShowBack: true,
        body: BlocConsumer<SearchBrandCategoryBloc, SearchBrandCategoryState>(
          listenWhen: (prevState, currentState) {
            if (prevState is LoadingBrandCategoryState) {
              DialogUtil.hideLoadingDialog(context);
            }
            return true;
          },
          listener: (context, state) async {
            if (state is ErrorBrandCategoryState) {
              DialogUtil.showErrorDialog(context, state.error);
            } else if (state is LoadingBrandCategoryState) {
              DialogUtil.showLoadingDialog(context);
            } else if (state is SearchCategoryState) {
              getBrandCategoryRs = state.getBrandCategoryRs;
            }
          },
          builder: (context, state) {
            if (state is SearchCategoryState) {
              return Scaffold(
                body: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.landscape) {
                      return buildLandscape(getBrandCategoryRs.mCH2List, widget.brand.brandId);
                    } else {
                      return buildPortrait(getBrandCategoryRs.mCH2List, widget.brand.brandId);
                    }
                  },
                ),
                floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget buildLandscape(List<MCH2List> mCH2List, String brandId) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCategory(mCH2List),
          CustomVericalDivider(),
          Expanded(
            child: CategoryList(
              leading: Container(
                child: FadeInImage.assetNetwork(
                  height: 360,
                  width: MediaQuery.maybeOf(context).size.width,
                  fit: BoxFit.fill,
                  placeholder:'assets/images/banner_main_catalog.jpg',
                  image: getIt<CategoryService>().getBrandBannerUrl(brandId),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
              mCH2List: mCH2List,
              brandId: widget.brand.brandId,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPortrait(List<MCH2List> mCH2List, String brandId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCategoryVertical(mCH2List, brandId),
        Expanded(
          child: CategoryList(
            brandId: widget.brand.brandId,
            mCH2List: mCH2List,
            scrollController: scrollController,
          ),
        ),
      ],
    );
  }

  Widget buildCategory(List<MCH2List> mCH2List) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(left: 2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  widget.brand.brandId,
                  style: Theme.of(context).textTheme.larger.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: mCH2List.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        onCategorySelect(index);
                      },
                      child: Text(
                        LanguageUtil.isTh(context) ? mCH2List[index].mCH2NameTH : mCH2List[index].mCH2NameEN,
                        style: Theme.of(context).textTheme.normal.copyWith(
                              fontWeight: FontWeight.bold,
                              color: selectedCategoryIndex != null && selectedCategoryIndex == index ? colorBlue7 : colorDark,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildCategoryVertical(List<MCH2List> mCH2List, String brandId) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorGrey3,
            offset: Offset(0, 1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              widget.brand.brandId,
              style: Theme.of(context).textTheme.larger.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: FadeInImage.assetNetwork(
              height: 360,
              width: MediaQuery.maybeOf(context).size.width,
              fit: BoxFit.fill,
              placeholder:'assets/images/banner_main_catalog.jpg',
              image: getIt<CategoryService>().getBrandBannerUrl(brandId),
              imageErrorBuilder: (context, error, stackTrace) {
                return Container();
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mCH2List.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          onCategorySelect(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: colorGrey3,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              LanguageUtil.isTh(context) ? mCH2List[index].mCH2NameTH : mCH2List[index].mCH2NameEN,
                              style: Theme.of(context).textTheme.normal.copyWith(
                                    color: selectedCategoryIndex != null && selectedCategoryIndex == index ? colorBlue7 : colorGrey1,
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
