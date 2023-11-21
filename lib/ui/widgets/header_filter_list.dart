import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/blocs/flag_compare/flag_compare_bloc.dart';
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_filter_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_solid_icon_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_close_dialog_button.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_list/search_product_list_bloc.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_checkbox.dart';

class HeaderFilterList extends StatefulWidget {
  final GetArticleFilterRs getArticleFilterRs;
  final MCH2List mch2;
  final MCH1CategoryList mch1;
  final String brandId;
  final CalculatorRs calculatorRs;

  const HeaderFilterList({Key key, this.getArticleFilterRs, this.mch2, this.mch1, this.brandId, this.calculatorRs}) : super(key: key);

  @override
  _HeaderFilterListState createState() => _HeaderFilterListState();
}

class _HeaderFilterListState extends State<HeaderFilterList> {
  GetArticleRq getArticleRq = GetArticleRq();
  bool isNotDefaultCategory = false; //สำหรับหมวดหมู่
  bool isNotDefaultBrand = false; //สำหรับแบรนด์
  bool isNotDefaultCalculator = false; //สำหรับ calculator
  bool isClearAll = false; //กดล้างทั้งหมด

  static final List<FilterChoice> orderList = [
    FilterChoice(
      false,
      'asc',
      'ราคาจากต่ำไปสูง',
      'Price low to high',
      SortList('asc', 'Price'),
    ),
    FilterChoice(
      false,
      'desc',
      'ราคาจากสูงไปต่ำ',
      'Price high to low',
      SortList('desc', 'Price'),
    )
  ];

  void onSort(List<FilterChoice> selectedList) {
    getArticleRq.sortList = [];
    if (selectedList.isNotEmpty) {
      getArticleRq.sortList.add(selectedList[0].obj as SortList);
    }

    onAddSearchEvent();
  }

  void onSearchBrand(List<FilterChoice> selectedList) {
    //กดเลือกจากใน overlay
    if (selectedList.isNotEmpty) {
      isNotDefaultBrand = true;
      List<String> brandStrLst = selectedList.map((e) => e.id).toList();

      getArticleRq.brandList = [];
      for (var brandStr in brandStrLst) {
        getArticleRq.brandList.add(GetArticleRqBrandList(brandStr));
      }
    } else {
      onSetDefaultBrand();
    }

    onAddSearchEvent();
  }

  void onPriceRange(double min, double max) {
    getArticleRq.minPrice = min;
    getArticleRq.maxPrice = max;

    onAddSearchEvent();
  }

  void onSearchCategory(List<FilterChoice> selectedList) {
    //กดเลือกจากใน overlay
    if (selectedList.isNotEmpty) {
      isNotDefaultCategory = true;
      var selectedCategoryLst = selectedList.map((e) => e.obj as CategoryList).toList();

      getArticleRq.mCHList = [];
      for (var mch in selectedCategoryLst) {
        for (var item in mch.searchTermList) {
          getArticleRq.mCHList.add(MCHList(item.mchId));
        }
      }
    } else {
      onSetDefaultCategory();
    }

    onAddSearchEvent();
  }

  void onSearchFeature(List<FilterChoice> selectedList, String featureCode) {
    getArticleRq.featureList = getArticleRq.featureList ?? [];
    getArticleRq.featureList.removeWhere((element) => element.featureCode == featureCode);

    for (var feature in selectedList) {
      getArticleRq.featureList.add(GetArticleRqFeatureList(feature.id, featureDesc: feature.textTh));
    }

    onAddSearchEvent();
  }

  void onAddSearchEvent() {
    BlocProvider.of<SearchProductListBloc>(context).add(
      SearchMchProductItemFilterEvent(getArticleRq, widget.getArticleFilterRs),
    );
  }

  void onSetDefaultCategory() {
    isNotDefaultCategory = false;
    //กด mch2
    if (widget.mch1 == null && widget.mch2 != null) {
      for (var mch1 in widget.mch2.mCH1CategoryList) {
        for (var item in mch1.searchTermList) {
          getArticleRq.mCHList.add(MCHList(item.mCHId));
        }
      }
    }
    //กด mch1
    else if (widget.mch1 != null) {
      for (var item in widget.mch1.searchTermList) {
        getArticleRq.mCHList.add(MCHList(item.mCHId));
      }
    }
    //แบบ search txt
    else {
      getArticleRq.mCHList?.clear();
    }
  }

  void onSetDefaultBrand() {
    isNotDefaultBrand = false;
    if (StringUtil.isNotEmpty(widget.brandId)) {
      getArticleRq.brandList.add(GetArticleRqBrandList(widget.brandId));
    } else {
      getArticleRq.brandList?.clear();
    }
  }

  void onSetDefaultCalculator() {
    isNotDefaultCalculator = false;
    if (widget.calculatorRs != null) {
      List<GetArticleRqFeatureList> featureList = []..add(GetArticleRqFeatureList(widget.calculatorRs.featureCode, featureDesc: (widget.calculatorRs.resultCalculator ?? 0).toString()));
      List<MCHList> mCHList = widget.calculatorRs.mchs?.map((e) => MCHList(e))?.toList();

      getArticleRq.featureList = getArticleRq.featureList ?? [];
      getArticleRq.featureList.addAll(featureList);

      getArticleRq.mCHList = getArticleRq.mCHList ?? [];
      getArticleRq.mCHList.addAll(mCHList);
    }
  }

  void onClearAllFilter() {
    getArticleRq.featureList?.clear();
    getArticleRq.minPrice = null;
    getArticleRq.maxPrice = null;
    isClearAll = true;

    onSetDefaultCategory();
    onSetDefaultBrand();
    onSetDefaultCalculator();

    BlocProvider.of<SearchProductListBloc>(context).add(
      SearchMchProductItemFilterEvent(getArticleRq, widget.getArticleFilterRs),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchProductListBloc, SearchProductListState>(builder: (context, state) {
      if (state is SearchMchProductItemState) {
        getArticleRq = state.getArticleRq;
        isClearAll = false;
      } else if (state is SearchMchProductItemFilterState) {
        getArticleRq = state.getArticleRq;
        isClearAll = false;
      }

      return Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                scrollDirection: Axis.horizontal,
                children: [
                  buildCompareButton(),
                  ButtonWithOverlay(
                    icon: MdiIcons.sort,
                    isSingleSelectMode: true,
                    isSelected: getArticleRq.sortList?.isNotEmpty ?? false,
                    title: 'text.filter_order_by'.tr(),
                    contentList: widget.getArticleFilterRs.minPrice.isNull ? [] : orderList.map((e) => FilterChoice(getArticleRq.sortList?.any((element) => element.sortBy == (e.obj as SortList).sortBy && element.sortType == (e.obj as SortList).sortType) ?? false, e.id, e.textTh, e.textEn, e.obj))?.toList(),
                    onComplete: (selectedList) {
                      onSort(selectedList);
                    },
                  ),
                  buildIconFilter(),
                  buildClearAllButton(),
                  ButtonWithOverlay(
                    isSelected: isNotDefaultBrand && (widget.getArticleFilterRs.brandList?.any((element) => getArticleRq.brandList?.any((e) => e.brandId == element.brandId) ?? false) ?? false),
                    title: 'text.filter_brand'.tr(),
                    contentList: widget.getArticleFilterRs.brandList?.map((item) => FilterChoice(isNotDefaultBrand && (getArticleRq.brandList?.any((e) => e.brandId == item.brandId) ?? false), item.brandId, item.brandId, item.brandId, item))?.toList(),
                    onComplete: (selectedList) {
                      onSearchBrand(selectedList);
                    },
                  ),
                  ButtonWithPriceRange(
                    isSelected: (getArticleRq.minPrice.isNotNull && getArticleRq.maxPrice != null) && (widget.getArticleFilterRs.minPrice != getArticleRq.minPrice || widget.getArticleFilterRs.maxPrice != getArticleRq.maxPrice),
                    minPrice: widget.getArticleFilterRs.minPrice,
                    maxPrice: widget.getArticleFilterRs.maxPrice?.ceilToDouble(),
                    selectedMinPrice: getArticleRq.minPrice ?? widget.getArticleFilterRs.minPrice,
                    selectedMaxPrice: getArticleRq.maxPrice?.ceilToDouble() ?? widget.getArticleFilterRs.maxPrice?.ceilToDouble(),
                    onComplete: (min, max) {
                      onPriceRange(min, max);
                    },
                  ),
                  ButtonWithOverlay(
                    isSelected: isNotDefaultCategory && (widget.getArticleFilterRs.categoryList?.any((element) => getArticleRq.mCHList?.any((e) => element.searchTermList?.any((k) => e.mCHId == k.mchId)) ?? false) ?? false),
                    title: 'text.filter_category'.tr(),
                    contentList: widget.getArticleFilterRs.categoryList?.map((category) => FilterChoice(isNotDefaultCategory && (getArticleRq.mCHList?.any((e) => category.searchTermList?.any((k) => e.mCHId == k.mchId)) ?? false), category.categoryId, category.categoryTH, category.categoryEN, category))?.toList(),
                    onComplete: (selectedList) {
                      onSearchCategory(selectedList);
                    },
                  ),
                  for (int index = 0; index < widget.getArticleFilterRs.featureList.length; index++)
                    ButtonWithOverlay(
                      isSelected: widget.getArticleFilterRs.featureList[index].featureDescList?.any((element) => getArticleRq.featureList?.any((e) => e.featureDesc == element.featureDescTH || e.featureDesc == element.featureDescEN) ?? false) ?? false,
                      title: LanguageUtil.isTh(context) ? widget.getArticleFilterRs.featureList[index].featureNameTH : widget.getArticleFilterRs.featureList[index].featureNameEN,
                      contentList: widget.getArticleFilterRs.featureList[index].featureDescList?.map((feature) => FilterChoice(getArticleRq.featureList?.any((desc) => desc.featureDesc == feature.featureDescTH || desc.featureDesc == feature.featureDescEN) ?? false, widget.getArticleFilterRs.featureList[index].featureCode, feature.featureDescTH, feature.featureDescEN, feature))?.toList(),
                      onComplete: (selectedList) {
                        onSearchFeature(selectedList, widget.getArticleFilterRs.featureList[index].featureCode);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildCompareButton() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: BlocBuilder<FlagCompareBloc, FlagCompareState>(
        builder: (context, state) {
          return ToggleButtons(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      NovaSolidIcon.move_left_right_1,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'text.filter_compare'.tr(),
                      style: Theme.of(context).textTheme.normal,
                    ),
                  ],
                ),
              ),
            ],
            onPressed: widget.getArticleFilterRs.featureList.isEmpty
                ? null
                : (int index) {
                    BlocProvider.of<FlagCompareBloc>(context).add(
                      ToggleFlagCompareEvent(),
                    );
                  },
            isSelected: [state.isCompared],
            borderRadius: BorderRadius.circular(20.0),
            fillColor: colorBlue5,
            selectedColor: colorGrey1,
            color: colorGrey1,
            selectedBorderColor: colorBlue3,
          );
        },
      ),
    );
  }

  Widget buildIconFilter() {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Icon(
        MdiIcons.filterOutline,
      ),
    );
  }

  Widget buildClearAllButton() {
    if (isNotDefaultBrand || isNotDefaultCategory || getArticleRq.featureList.isNotNE || ((getArticleRq.minPrice.isNotNull && getArticleRq.maxPrice.isNotNull) && (getArticleRq.minPrice != widget.getArticleFilterRs.minPrice || getArticleRq.maxPrice != widget.getArticleFilterRs.maxPrice))) {
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: colorBlue5,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  'text.filter_clear_all'.tr(),
                  style: Theme.of(context).textTheme.smaller.copyWith(
                        color: colorBlue7,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                onClearAllFilter();
              },
            ),
          ),
        ),
      );
    }
    return Container();
  }
}

class ButtonWithOverlay extends StatefulWidget {
  final String title;
  final List<FilterChoice> contentList;
  final Function(List<FilterChoice>) onComplete;
  final IconData icon;
  bool isSelected;
  bool isSingleSelectMode;

  ButtonWithOverlay({Key key, this.title, this.contentList, this.onComplete, this.isSelected, this.isSingleSelectMode = false, this.icon}) : super(key: key);

  @override
  _ButtonWithOverlayState createState() => _ButtonWithOverlayState();
}

class _ButtonWithOverlayState extends State<ButtonWithOverlay> {
  OverlayEntry _overlay;
  OverlayState _overlayState;
  LayerLink _layerLink = LayerLink();
  List<bool> isSelectedButton = [false]; //สำหรับ toggle button
  bool isOpenLayout = false; //กดเลือกเฉยๆ
  num lengthList = 5; //สำหรับสร้าง panel ขวาหรือล่าง
  List<FilterChoice> selectedList = [];
  bool isValueChange = false;

  @override
  void initState() {
    super.initState();
    _overlayState = Overlay.of(context);
  }

  void onButtonClick() {
    isValueChange = false;
    if (!isOpenLayout) {
      isOpenLayout = !isOpenLayout;
      _overlay = _createPanelOverlay();
      Overlay.of(context).insert(_overlay);
    }
  }

  //ทั้งคลิกข้างนอกทั้งกดปิด
  void onConfirm() {
    setState(() {
      isOpenLayout = false;
    });
    _overlay?.remove();
    selectedList?.clear();
    selectedList.addAll(widget.contentList.where((element) => element.isSelected).toList());
    widget.onComplete(selectedList);
  }

  void onSelect(int index) {
    _overlayState.setState(() {
      if (widget.isSingleSelectMode) {
        widget.contentList.forEach((element) => element.isSelected = false);
        widget.contentList[index].isSelected = true;
      } else {
        widget.contentList[index].isSelected = !widget.contentList[index].isSelected;
      }
    });
    isValueChange = true;
  }

  void onCancel() {
    setState(() {
      isOpenLayout = false;
    });
    _overlay?.remove();
    selectedList?.clear();
  }

  void onClear() {
    if (widget.contentList.any((element) => element.isSelected)) {
      isValueChange = true;
    }
    _overlayState.setState(() {
      widget.contentList.forEach((element) => element.isSelected = false);
    });
  }

  void onValueChange() {
    isValueChange ? onConfirm() : onCancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchProductListBloc, SearchProductListState>(builder: (context, state) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: colorGrey3,
                offset: Offset(0, 1),
                blurRadius: 1.0,
              ),
            ],
          ),
          child: ToggleButtons(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                constraints: BoxConstraints(
                  minWidth: 100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null)
                      Icon(
                        widget.icon,
                      ),
                    if (widget.icon != null)
                      SizedBox(
                        width: 5,
                      ),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.normal,
                    ),
                  ],
                ),
              ),
            ],
            onPressed: widget.contentList.isEmpty
                ? null
                : (int index) {
                    onButtonClick();
                    setState(() {
                      isSelectedButton[index] = isOpenLayout;
                    });
                  },
            isSelected: isSelectedButton,
            borderRadius: BorderRadius.circular(20.0),
            fillColor: isOpenLayout
                ? colorBlue4
                : widget.isSelected
                    ? colorBlue5
                    : Colors.white,
            selectedColor: colorGrey1,
            color: colorGrey1,
            selectedBorderColor: isOpenLayout || widget.isSelected ? colorBlue3 : colorGrey3,
          ),
        ),
      );
    });
  }

  Widget buildBottomFilterPanel() {
    return Container(
      decoration: BoxDecoration(
        color: colorGrey4,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.contentList.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: colorBlue5,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Text(
                            'text.filter_clear'.tr(),
                            style: Theme.of(context).textTheme.smaller.copyWith(
                                  color: colorBlue7,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          onClear();
                        },
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CustomCloseDialogButton(
                        isInkStyle: false,
                        onTap: () {
                          onValueChange();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.contentList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            CustomCheckbox(
                              isCheckIcon: true,
                              value: widget.contentList[index].isSelected,
                              onChanged: widget.contentList.length == 1
                                  ? null
                                  : (value) {
                                      onSelect(index);
                                    },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                LanguageUtil.isTh(context) ? widget.contentList[index].textTh : widget.contentList[index].textEn,
                                style: Theme.of(context).textTheme.small,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRightFilterPanel() {
    return Container(
      width: 350,
      color: colorGrey4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomCloseDialogButton(
                isInkStyle: false,
                onTap: () {
                  onValueChange();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.larger.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: colorBlue5,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1),
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Text(
                    'text.filter_clear'.tr(),
                    style: Theme.of(context).textTheme.smaller.copyWith(
                          color: colorBlue7,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  onClear();
                },
              ),
            ),
            SizedBox(height: 5),
            Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.contentList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            isCheckIcon: true,
                            value: widget.contentList[index].isSelected,
                            onChanged: (value) {
                              onSelect(index);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              LanguageUtil.isTh(context) ? widget.contentList[index].textTh : widget.contentList[index].textEn,
                              style: Theme.of(context).textTheme.small,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
            Container(
              width: 350,
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: colorBlue7,
                  onPrimary: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: () {
                  onValueChange();
                },
                child: Text(
                  'text.filter_search'.tr(),
                  style: Theme.of(context).textTheme.small.copyWith(
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width)
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 1,
                  )),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createPanelOverlay() {
    RenderBox renderBox = context.findRenderObject(); // พิกัด และขนาดการ Render ของ Widget นี้
    var size = renderBox.size; // ขนาดของ Widget
    var offset = renderBox.localToGlobal(Offset.zero); // พิกัด X,Y ที่ Widget นี้แสดงอยู่
    // print('offset.dx : ${offset.dx}, offset.dy : ${offset.dy}, size.width : ${size.width}');
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () {
                onValueChange();
              },
            ),
          ),
          if (widget.contentList.length <= lengthList)
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              width: 350,
              child: CompositedTransformFollower(
                targetAnchor: (offset.dx + 350) > MediaQuery.maybeOf(context).size.width ? Alignment.topRight : Alignment.topLeft,
                followerAnchor: (offset.dx + 350) > MediaQuery.maybeOf(context).size.width ? Alignment.topRight : Alignment.topLeft,
                link: _layerLink,
                offset: Offset(0, size.height + 5.0),
                child: Material(
                  child: buildBottomFilterPanel(),
                ),
              ),
            ),
          if (widget.contentList.length > lengthList)
            Align(
              alignment: Alignment.topRight,
              child: Material(
                child: buildRightFilterPanel(),
              ),
            ),
        ],
      ),
    );
  }
}

//สำหรับ ราคา
class ButtonWithPriceRange extends StatefulWidget {
  final Function(double, double) onComplete;
  final double minPrice;
  final double maxPrice;
  double selectedMinPrice;
  double selectedMaxPrice;
  bool isSelected;

  ButtonWithPriceRange({Key key, this.onComplete, this.minPrice, this.maxPrice, this.selectedMinPrice, this.selectedMaxPrice, this.isSelected}) : super(key: key);

  @override
  _ButtonWithPriceRangeState createState() => _ButtonWithPriceRangeState();
}

class _ButtonWithPriceRangeState extends State<ButtonWithPriceRange> {
  double selectedLowerValue;
  double selectedUpperValue;

  LayerLink _layerLink = LayerLink();
  OverlayState _overlayState;
  OverlayEntry _overlay;
  List<bool> isSelected = [false];
  bool isOpenLayout = false; //กดเลือกเฉยๆ
  bool isValueChange = false;

  @override
  void initState() {
    super.initState();
    _overlayState = Overlay.of(context);
    selectedLowerValue = widget.selectedMinPrice ?? widget.minPrice;
    selectedUpperValue = widget.selectedMaxPrice ?? widget.maxPrice;
    widget.selectedMinPrice = selectedLowerValue;
    widget.selectedMaxPrice = selectedUpperValue;
  }

  void onPriceRangeButtonClick() {
    isValueChange = false;
    if (!isOpenLayout) {
      isOpenLayout = !isOpenLayout;
      _overlay = _createPriceRangePanelOverlay();
      Overlay.of(context).insert(_overlay);
    }
  }

  //ทั้งคลิกข้างนอกทั้งกดปิด
  void onConfirm() {
    setState(() {
      isOpenLayout = false;
    });
    _overlay?.remove();

    widget.onComplete(widget.selectedMinPrice, widget.selectedMaxPrice);
  }

  void onCancelPriceRange() {
    setState(() {
      isOpenLayout = false;
    });
    _overlay?.remove();
  }

  void onClear() {
    if (widget.selectedMinPrice != widget.minPrice || widget.selectedMaxPrice != widget.maxPrice) {
      isValueChange = true;
    }
    _overlayState.setState(() {
      selectedLowerValue = widget.minPrice;
      selectedUpperValue = widget.maxPrice;
      widget.selectedMinPrice = selectedLowerValue;
      widget.selectedMaxPrice = selectedUpperValue;
    });
  }

  void onPriceChange() {
    isValueChange ? onConfirm() : onCancelPriceRange();
  }

  @override
  Widget build(BuildContext context) {
    // print('isOpenLayout : ${isOpenLayout}');
    // print('isSelected : ${widget.isSelected}');
    // print('selectedLowerValue : $selectedLowerValue');
    // print('widget.selectedMinPrice : ${widget.selectedMinPrice}');
    // print('widget.selectedMaxPrice : ${widget.selectedMaxPrice}');
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: ToggleButtons(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              constraints: BoxConstraints(
                minWidth: 100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'text.filter_price'.tr(),
                    style: Theme.of(context).textTheme.normal,
                  ),
                ],
              ),
            ),
          ],
          onPressed: widget.minPrice.isNull
              ? null
              : (int index) {
                  onPriceRangeButtonClick();
                  setState(() {
                    isSelected[index] = isOpenLayout;
                  });
                },
          isSelected: isSelected,
          borderRadius: BorderRadius.circular(20.0),
          fillColor: isOpenLayout
              ? colorBlue4
              : widget.isSelected
                  ? colorBlue5
                  : Colors.white,
          selectedColor: colorGrey1,
          color: colorGrey1,
          selectedBorderColor: isOpenLayout || widget.isSelected ? colorBlue3 : colorGrey3,
        ),
      ),
    );
  }

  Widget buildPriceRangePanel() {
    return Container(
      decoration: BoxDecoration(
        color: colorGrey4,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorBlue5,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Text(
                        'text.filter_clear'.tr(),
                        style: Theme.of(context).textTheme.smaller.copyWith(
                              color: colorBlue7,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      onClear();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CustomCloseDialogButton(
                    isInkStyle: false,
                    onTap: () {
                      onPriceChange();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'text.filter_min'.tr(),
                    style: Theme.of(context).textTheme.smaller.copyWith(
                          color: colorGrey1,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'text.filter_max'.tr(),
                    style: Theme.of(context).textTheme.smaller.copyWith(
                          color: colorGrey1,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              child: FlutterSlider(
                values: [widget.selectedMinPrice, widget.selectedMaxPrice],
                rangeSlider: true,
                max: widget.maxPrice,
                min: widget.minPrice,
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: colorBlue7),
                    ),
                  ),
                ),
                rightHandler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: colorBlue7),
                    ),
                  ),
                ),
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorBlue4,
                  ),
                  inactiveTrackBarHeight: 12,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorBlue7,
                  ),
                  activeTrackBarHeight: 12,
                ),
                tooltip: FlutterSliderTooltip(
                  alwaysShowTooltip: false,
                  positionOffset: FlutterSliderTooltipPositionOffset(top: 15),
                  textStyle: Theme.of(context).textTheme.smaller,
                  format: (String value) {
                    return '${StringUtil.getDefaultCurrencyFormat(int.parse(value))}';
                  },
                ),
                step: FlutterSliderStep(
                  rangeList: [
                    FlutterSliderRangeStep(from: widget.minPrice, to: widget.maxPrice, step: 1),
                  ],
                ),
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  widget.selectedMinPrice = lowerValue;
                  widget.selectedMaxPrice = upperValue;
                  isValueChange = true;
                },
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    selectedLowerValue = lowerValue;
                    selectedUpperValue = upperValue;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${StringUtil.getDefaultCurrencyFormat(widget.selectedMinPrice)} - ${StringUtil.getDefaultCurrencyFormat(widget.selectedMaxPrice)}',
                  style: Theme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'text.baht'.tr(),
                  style: Theme.of(context).textTheme.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createPriceRangePanelOverlay() {
    RenderBox renderBox = context.findRenderObject(); // พิกัด และขนาดการ Render ของ Widget นี้
    var size = renderBox.size; // ขนาดของ Widget
    var offset = renderBox.localToGlobal(Offset.zero); // พิกัด X,Y ที่ Widget นี้แสดงอยู่

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () {
                onPriceChange();
              },
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 5.0,
            width: 350,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0.0, size.height + 5.0),
              child: Material(
                child: buildPriceRangePanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChoice {
  bool isSelected;
  String id;
  String textTh;
  String textEn;
  dynamic obj;

  FilterChoice(this.isSelected, this.id, this.textTh, this.textEn, this.obj);
}
