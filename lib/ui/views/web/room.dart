import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/widgets/category_main.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:easy_localization/easy_localization.dart';

class RoomPage extends StatefulWidget {
  final RoomList roomSelected;
  final Color backgroundColor;

  const RoomPage({Key key, this.roomSelected, this.backgroundColor}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  AutoScrollController scrollController;
  int selectedCategoryIndex = 0;

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
    String label = LanguageUtil.isTh(context) ? widget.roomSelected.roomNameTH : widget.roomSelected.roomNameEN;

    return CommonLayout(
      isShowBack: true,
      bodyBackgroundColor: Colors.white,
      body: Scaffold(
        body: CategoryMain(
          scrollController: scrollController,
          onMCH2Select: onMCH2Select,
          selectedCategoryIndex: selectedCategoryIndex,
          listMch2: widget.roomSelected.mch2List,
          backgroundColor: widget.backgroundColor,
          nameHeader: 'text.product_category'.tr(),
          name: label,
          imgUrl: widget.roomSelected.roomImgUrl,
        ),
        floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
      ),
    );
  }
}
