import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';

class SearchResultText extends StatelessWidget {
  final int result;
  final String searchText;

  const SearchResultText({Key key, this.result, this.searchText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
            child: Text(
          '${'text.search_results'.tr()} ',
          style: Theme.of(context).textTheme.large.copyWith(
                fontWeight: FontWeight.bold,
              ),
        )),
        if (result.isNull || result == 0)
          WidgetSpan(
            child: Text(
              'text.search_no_matching_items_were_found'.tr(),
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorRed1,
                  ),
            ),
          ),
        if (result > 0)
          WidgetSpan(
              child: Text(
            '${'text.search_found'.tr()} : ',
            style: Theme.of(context).textTheme.large.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )),
        if (result > 0)
          WidgetSpan(
            child: Text(
              StringUtil.toStringFormat(result, '#,##0'),
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorBlue2_2,
                  ),
            ),
          ),
        if (result > 0)
          WidgetSpan(
            child: Text(
              ' ${'text.search_items'.tr()}',
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        if(searchText.isNotNE)
          WidgetSpan(
            child: Text(
              ' ${'text.search_for'.tr()} \u0060',
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        if(searchText.isNotNE)
          WidgetSpan(
            child: Text(
              searchText,
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorBlue2_2,
                  ),
            ),
          ),
        if(searchText.isNotNE)
          WidgetSpan(
            child: Text(
              '\u0060',
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
      ]),
    );
  }
}
