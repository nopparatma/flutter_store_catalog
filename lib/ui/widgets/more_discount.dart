import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'nova_solid_icon_icons.dart';
import 'package:easy_localization/easy_localization.dart';

class MoreDiscount extends StatefulWidget{
  final num discountPrice;

  const MoreDiscount({Key key, this.discountPrice }) : super(key: key);

  @override
  _MoreDiscount createState() => _MoreDiscount();
}

class _MoreDiscount extends State<MoreDiscount>{

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(color: colorRed2, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(NovaSolidIcon.tag_dollar, color: colorRed1),
          SizedBox(width: 10),
          Text(
            '${'text.more_discount'.tr()} ${StringUtil.getDefaultCurrencyFormat(widget.discountPrice)} ${'text.baht'.tr()}',
            style: Theme.of(context).textTheme.small.copyWith(color: colorRed1,),
          ),
        ],
      ),
    );
  }
}