import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math';

class TenderList extends StatefulWidget {
  final List<SuggestTender> tenderList;
  final num totalAmount;
  final bool isBigFirst;
  final Function onSelected;
  final SuggestTender value;

  TenderList({
    Key key,
    this.tenderList,
    this.totalAmount,
    this.isBigFirst = false,
    this.onSelected,
    this.value,
  }) : super(key: key);

  @override
  _TenderListState createState() => _TenderListState();
}

class _TenderListState extends State<TenderList> {
  num cheapest;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  void onSelected(SuggestTender tender) {
    setState(() {
      widget.onSelected(tender);
    });
  }

  @override
  Widget build(BuildContext context) {
    num minValue = widget.tenderList.map((e) => e.trnAmt).reduce(min);
    num maxValue = widget.tenderList.map((e) => e.trnAmt).reduce(max);
    cheapest = (minValue != maxValue) ? minValue : null;
    return buildCategoryBody();
  }

  Widget buildCategoryBody() {
    return LayoutBuilder(builder: (context, constraints) {
      return StaggeredGridView.extent(
        key: ValueKey<double>(constraints.maxWidth),
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: widget.tenderList.map((e) {
          return CategoryTile(
            tender: e,
            isFirst: widget.tenderList.indexOf(e) == 0 && widget.isBigFirst,
            specialPrice: e.trnAmt < widget.totalAmount,
            isSelected: widget.value == e,
            cheapest: cheapest,
            onSelected: widget.onSelected != null ? onSelected : null,
          );
        }).toList(),
        staggeredTiles: widget.tenderList.map((e) {
          if (widget.tenderList.indexOf(e) == 0 && widget.isBigFirst)
            return StaggeredTile.fit(2);
          else
            return StaggeredTile.fit(1);
        }).toList(),
      );
    });
  }
}


class CategoryTile extends StatelessWidget {
  final SuggestTender tender;
  final bool isFirst;
  final bool specialPrice;
  final bool isSelected;
  final num cheapest;
  final Function onSelected;

  const CategoryTile({this.tender, this.isFirst, this.specialPrice, this.isSelected, this.cheapest, this.onSelected});

  @override
  Widget build(BuildContext context) {
    TextStyle priceStyle = isFirst ? Theme.of(context).textTheme.xlarger : Theme.of(context).textTheme.normal;

    if (specialPrice) {
      priceStyle = priceStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.red);
    } else {
      priceStyle = priceStyle.copyWith(fontWeight: FontWeight.bold, color: colorBlue2);
    }

    final double height = 80;

    return Container(
      height: isFirst ? (height * 2) + 4 : height,
      child: Card(
        color: isSelected ? colorBlue5 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            color: isSelected ? colorBlue7 : Colors.white,
          ),
        ),
        elevation: 5,
        child: InkWell(
          onTap: onSelected != null ?  () => onSelected(tender) : null,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.fill,
                    placeholder: 'assets/images/non_article_image.png',
                    image: ImageUtil.getFullURL(tender.imgUrl),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/non_article_image.png',
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
                if (isFirst)
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Stack(
                        children: [
                          if (cheapest == tender.trnAmt)
                            Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxHeight: 30),
                                  child: Image.asset(
                                    'assets/images/${context.locale.toString()}/cheapest.png',
                                  ),
                                ),
                              ],
                            ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                StringUtil.getDefaultCurrencyFormat(tender.trnAmt),
                                style: priceStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isFirst)
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (cheapest == tender.trnAmt)
                            Container(
                              constraints: BoxConstraints(maxHeight: 20),
                              child: Image.asset(
                                'assets/images/${context.locale.toString()}/cheapest.png',
                              ),
                            ),
                          Text(
                            StringUtil.getDefaultCurrencyFormat(tender.trnAmt),
                            style: priceStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                Text(
                  'text.baht'.tr(),
                  style: Theme.of(context).textTheme.small,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
