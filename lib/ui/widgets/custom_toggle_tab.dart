import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';

class CustomToggleTab extends StatefulWidget {
  final ValueChanged<int> selection;
  final List<String> names;
  final TextStyle selectedTextStyle;
  final TextStyle unSelectedTextStyle;
  final Color indicatorColor;
  final Color indicatorBorderColor;
  final double indicatorBorderWidth;
  final double indicatorBorderRadius;
  final double width;
  final double height;
  final TabController tabController;
  final bool isScrollable;

  CustomToggleTab({
    this.names,
    this.selection,
    this.selectedTextStyle,
    this.unSelectedTextStyle,
    this.indicatorColor,
    this.indicatorBorderColor,
    this.indicatorBorderWidth = 1,
    this.indicatorBorderRadius = 50,
    this.width,
    this.height = 35,
    this.tabController,
    this.isScrollable = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomToggleTabState();
  }
}

class _CustomToggleTabState extends State<CustomToggleTab> with TickerProviderStateMixin  {
  List<Tab> rows = [];
  TabController defaultTabController;

  TextStyle get selectedTextStyle =>
      widget.selectedTextStyle ??
      Theme.of(context).textTheme.normal.copyWith(
            color: colorBlue7,
            fontWeight: FontWeight.normal,
          );

  TextStyle get unSelectedTextStyle =>
      widget.unSelectedTextStyle ??
      Theme.of(context).textTheme.normal.copyWith(
            color: colorGrey2,
            fontWeight: FontWeight.normal,
          );

  @override
  void initState() {
    super.initState();
    defaultTabController ??= TabController(length: widget.names.length, vsync: this, initialIndex: 0);
  }

  @override
  dispose() {
    defaultTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: colorGrey3,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TabBar(
        isScrollable: widget.isScrollable,
        controller: widget.tabController ?? defaultTabController,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: ContainerTabIndicator(
          color: widget.indicatorColor ?? Colors.white,
          borderColor: widget.indicatorBorderColor ?? colorBlue7,
          borderWidth: widget.indicatorBorderWidth,
          height: widget.height != null ? widget.height * 1.15 : widget.height,
          radius: BorderRadius.circular(widget.indicatorBorderRadius),
        ),
        tabs: _tabs(widget.names),
        onTap: (value) {
          setState(() {
            widget.selection(value);
          });
        },
      ),
    );
  }

  List<Tab> _tabs(List<String> names) {
    rows.clear();
    for (var tab = 0; tab < names.length; tab++) {
      rows.add(
        Tab(
          child: Container(
            child: Text(
              names[tab],
              textAlign: TextAlign.center,
              style: (widget.tabController ?? defaultTabController).index == tab ? selectedTextStyle : unSelectedTextStyle,
            ),
          ),
        ),
      );
    }
    return rows;
  }
}
