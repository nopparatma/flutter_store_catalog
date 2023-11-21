import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

import 'category_list.dart';
import 'custom_vertical_divider.dart';

class CategoryMain extends StatelessWidget {
  final List<MCH2List> listMch2;
  final Color backgroundColor;
  final AutoScrollController scrollController;
  final Function onMCH2Select;
  final String name;
  final String nameHeader;
  final String imgUrl;
  final int selectedCategoryIndex;

  const CategoryMain({
    Key key,
    this.listMch2,
    this.backgroundColor,
    this.scrollController,
    this.onMCH2Select,
    this.name,
    this.nameHeader,
    this.imgUrl,
    this.selectedCategoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return buildLandscape(context);
        } else {
          return buildPortrait(context);
        }
      },
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCategory(context),
          CustomVericalDivider(),
          buildCategoryListMch1(context),
        ],
      ),
    );
  }

  Widget buildPortrait(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCategoryVertical(context),
          buildCategoryListMch1(context),
        ],
      ),
    );
  }

  Widget buildCategoryListMch1(BuildContext context) {
    return Expanded(
      child: CategoryList(
        mCH2List: listMch2,
        scrollController: scrollController,
      ),
    );
  }

  Widget buildCategory(BuildContext context) {
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
                  StringUtil.isNullOrEmpty(nameHeader) ? '' : nameHeader,
                  style: Theme.of(context).textTheme.larger.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                height: 120,
                child: CategoryTile(backgroundColor, name, imgUrl, true),
              ),
              SizedBox(height: 16),
              if (listMch2 != null && listMch2.length > 0)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listMch2.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          onMCH2Select(index);
                        },
                        child: Text(
                          LanguageUtil.isTh(context) ? listMch2[index].mCH2NameTH : listMch2[index].mCH2NameEN,
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

  Widget buildCategoryVertical(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              StringUtil.isNullOrEmpty(nameHeader) ? '' : nameHeader,
              style: Theme.of(context).textTheme.larger.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Container(
            height: 130,
            width: 320,
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: CategoryTile(backgroundColor, name, imgUrl, true),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  child: (listMch2 == null || listMch2.length == 0)
                      ? Container()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: listMch2.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                onMCH2Select(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
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
                                    LanguageUtil.isTh(context) ? listMch2[index].mCH2NameTH : listMch2[index].mCH2NameEN,
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

class CategoryTile extends StatelessWidget {
  const CategoryTile(this.backgroundColor, this.label, this.imageUrl, this.isColorHorizontalAlignment);

  final Color backgroundColor;
  final String label;
  final String imageUrl;
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
              fit: BoxFit.cover,
              placeholder: 'assets/images/non_article_image.png',
              image: ImageUtil.getFullURL(imageUrl),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/non_article_image.png',
                  fit: BoxFit.cover,
                );
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
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    StringUtil.isNullOrEmpty(label) ? '' : label,
                    style: Theme.of(context).textTheme.large.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
