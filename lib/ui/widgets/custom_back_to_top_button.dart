import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'nova_solid_icon_icons.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomBackToTopButton extends StatefulWidget {
  ScrollController scrollController;
  final double marginBottom;
  CustomBackToTopButton({this.scrollController, this.marginBottom = 0});

  @override
  _CustomBackToTopButtonState createState() => _CustomBackToTopButtonState();
}

class _CustomBackToTopButtonState extends State<CustomBackToTopButton> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(onScrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScrollListener);
    super.dispose();
  }

  onScrollListener() {
    setState(() {
      isVisible = (widget.scrollController.position.pixels > 200.0);
    });
  }

  onBackToTop() {
    widget.scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: !isVisible
          ? SizedBox()
          : Container(
              width: 78,
              height: 78,
              margin: EdgeInsets.only(bottom: widget.marginBottom),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: colorBlue7,
                  elevation: 4,
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(NovaSolidIcon.arrow_shift, size: 20.0, color: Colors.white),
                      SizedBox(height: 3),
                      Text(
                        'text.back_to_top'.tr(namedArgs: {"newLine": "\n"}),
                        style: Theme.of(context).textTheme.small.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  onBackToTop();
                },
              ),
            ),
    );
  }
}
