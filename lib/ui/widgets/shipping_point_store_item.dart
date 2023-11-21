import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

import 'nova_solid_icon_icons.dart';

class ShippingPointStoreItem extends StatelessWidget {
  final ShippingPointList shippingPointStore;
  final bool isSelected;
  final Function onPressedShippingPoint;

  const ShippingPointStoreItem({this.shippingPointStore, this.isSelected = false, this.onPressedShippingPoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: colorGreyBlue,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorGreyBlueShadow,
            blurRadius: 3.0,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.all(15),
          primary: isSelected ? colorBlue4 : colorGrey4,
          shadowColor: colorGreyBlueShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: BorderSide(
            width: 1,
            color: isSelected ? colorBlue7 : colorGrey4,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  NovaSolidIcon.places_warehouse_2,
                  size: 40,
                  color: colorDark,
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'สาขา ${shippingPointStore?.shippingPointName ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                  ),
                  Scrollbar(
                    isAlwaysShown: false,
                    child: Text(
                      shippingPointStore?.shippingPointAddress ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal, color: colorDark),
                    ),
                  ),
                  Text(
                    'โทร ${shippingPointStore?.shippingPointPhoneNo ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal, color: colorDark),
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          if (onPressedShippingPoint != null) onPressedShippingPoint(shippingPointStore);
        },
      ),
    );
  }
}
