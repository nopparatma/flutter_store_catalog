import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeProCare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: 100,
                child: Image.asset('assets/images/homeprocare.png'),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'text.homepro_care.first'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'text.homepro_care.second'.tr(),
                    style: Theme.of(context).textTheme.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
