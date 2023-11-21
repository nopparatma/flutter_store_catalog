import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

class HirePurchaseBankList extends StatefulWidget {
  final List<MstBank> bankList;
  final MstBank value;
  final Function onSelected;

  HirePurchaseBankList({
    Key key,
    this.bankList,
    this.value,
    this.onSelected,
  }) : super(key: key);

  @override
  _HirePurchaseBankListState createState() => _HirePurchaseBankListState();
}

class _HirePurchaseBankListState extends State<HirePurchaseBankList> {

  @override
  Widget build(BuildContext context) {
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
        children: widget.bankList.map((e) {
          return InkWell(
            onTap: () {
              setState(() {
                widget.onSelected(e);
              });
            } ,
            child: CategoryTile(e, e == widget.value),
          );
        }).toList(),
        staggeredTiles: widget.bankList.map((e) {
          return StaggeredTile.fit(1);
        }).toList(),
      );
    });
  }
}

class CategoryTile extends StatelessWidget {
  final MstBank bank;
  final bool isSelected;

  const CategoryTile(this.bank, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
          color: isSelected ? colorBlue5 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: isSelected ? colorBlue7 : Colors.white,
            ),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Image.memory(Base64Decoder().convert(bank.image?.split(',')[1])),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      bank.bankName,
                      style: Theme.of(context).textTheme.normal.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorBlue2,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
