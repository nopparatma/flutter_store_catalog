import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:easy_localization/easy_localization.dart';

import '../router.dart';

class CategoryList extends StatefulWidget {
  final List<MCH2List> mCH2List;
  final AutoScrollController scrollController;
  final Widget leading;
  final String brandId;

  CategoryList({Key key, this.mCH2List, this.scrollController, this.leading, this.brandId}) : super(key: key);

  @override
  _CategoryList createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList> {
  void onSelect(MCH2List mch2, MCH1CategoryList mch1) {
    Navigator.of(context).pushNamed(WebRoutePaths.Products, arguments: {'mch2': mch2, 'mch1': mch1, 'brandId': widget.brandId});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: (widget.mCH2List == null || widget.mCH2List.length == 0)
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              controller: widget.scrollController,
              itemCount: widget.mCH2List.length + (widget.leading != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && widget.leading != null) {
                  index = index - 1;
                  return AutoScrollTag(
                    controller: widget.scrollController,
                    index: index,
                    key: ValueKey(index),
                    child: widget.leading,
                  );
                }

                if (widget.leading != null) {
                  index = index - 1;
                }
                return AutoScrollTag(
                  controller: widget.scrollController,
                  index: index,
                  key: ValueKey(index),
                  child: buildMCH2Item(index),
                );
              },
            ),
    );
  }

  buildMCH2Item(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              LanguageUtil.isTh(context) ? widget.mCH2List[index].mCH2NameTH : widget.mCH2List[index].mCH2NameEN,
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (widget.mCH2List[index].mCH1CategoryList != null && widget.mCH2List[index].mCH1CategoryList.length > 0)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSelectAllItem(index),
                buildMCH1Item(mch2: widget.mCH2List[index]),
              ],
            ),
        ],
      ),
    );
  }

  buildSelectAllItem(int index) {
    return InkWell(
      child: Container(
        height: 300,
        width: 250,
        child: Card(
          elevation: 4,
          child: Center(
            child: Container(
              height: 180,
              width: 180,
              child: Card(
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorGrey4,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apps_rounded,
                        size: 50,
                        color: colorGrey1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'text.show_all_products'.tr(args: ['\n']),
                          style: Theme.of(context).textTheme.normal.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorGrey1,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        onSelect(widget.mCH2List[index], null);
      },
    );
  }

  buildMCH1Item({MCH2List mch2}) {
    return Expanded(
      child: Container(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: mch2.mCH1CategoryList.length,
          itemBuilder: (context, index2) {
            return InkWell(
              child: Container(
                height: 300,
                width: 250,
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeInImage.assetNetwork(
                        height: 230,
                        placeholder: 'assets/images/non_article_image.png',
                        image: ImageUtil.getFullURL(mch2.mCH1CategoryList[index2].mCH1ImgUrl),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/non_article_image.png', height: 230);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          LanguageUtil.isTh(context) ? mch2.mCH1CategoryList[index2].mCH1NameTH : mch2.mCH1CategoryList[index2].mCH1NameEN,
                          style: Theme.of(context).textTheme.normal.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                onSelect(mch2, mch2.mCH1CategoryList[index2]);
              },
            );
          },
        ),
      ),
    );
  }
}
