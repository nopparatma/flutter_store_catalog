import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/widgets/category_main.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryPage extends StatefulWidget {
  final MCH3List mch3;
  final Color backgroundColor;

  const CategoryPage({Key key, this.mch3, this.backgroundColor}) : super(key: key);

  @override
  _CategoryPage createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage> {
  AutoScrollController scrollController;
  int selectedCategoryIndex = 0;

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

  void onMCH2Select(int index) {
    setState(() => selectedCategoryIndex = index);
    scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      isShowBack: true,
      bodyBackgroundColor: Colors.white,
      body: Scaffold(
        body: CategoryMain(
          scrollController: scrollController,
          onMCH2Select: onMCH2Select,
          selectedCategoryIndex: selectedCategoryIndex,
          listMch2: widget.mch3.mCH2List,
          backgroundColor: widget.backgroundColor,
          nameHeader: 'text.product_category'.tr(),
          name: LanguageUtil.isTh(context) ? widget.mch3.mCH3NameTH : widget.mch3.mCH3NameEN,
          imgUrl: widget.mch3.mCH3ImgUrl,
        ),
        floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
      ),
    );
  }
}
