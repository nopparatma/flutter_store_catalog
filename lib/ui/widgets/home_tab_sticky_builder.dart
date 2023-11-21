import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

class HomeTabStickyBuilder extends StatefulWidget {
  final TabController tabController;
  final ValueChanged<int> onDestinationSelected;
  final AutoScrollController scrollController;
  final Widget header;
  final Widget body;

  static const List<String> tabs = [
    'text.tab_select_by_category',
    'text.tab_select_by_brand',
    'text.tab_select_by_room',
  ];

  HomeTabStickyBuilder({Key key, this.tabController, this.onDestinationSelected, this.scrollController, this.header, this.body}) : super(key: key);

  @override
  _HomeTabStickyBuilderState createState() => _HomeTabStickyBuilderState();
}

class _HomeTabStickyBuilderState extends State<HomeTabStickyBuilder> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;

        return StickyHeaderBuilder(
          controller: widget.scrollController,
          builder: (context, stuckAmount) {
            stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
            bool isVisibleTopBoxPortrait = (stuckAmount >= 0.5) && isPortrait;

            return Container(
              margin: EdgeInsets.only(left: 2),
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(height: isVisibleTopBoxPortrait ? 80 : 0),
                    vsync: this,
                  ),
                  Center(
                    child: TabBar(
                      controller: widget.tabController,
                      isScrollable: true,
                      unselectedLabelColor: colorDark,
                      indicator: BubbleTabIndicator(
                        indicatorColor: colorDark,
                        tabBarIndicatorSize: TabBarIndicatorSize.label,
                        indicatorRadius: 8,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                      tabs: HomeTabStickyBuilder.tabs.map((e) => Tab(child: Text(e.tr(), style: Theme.of(context).textTheme.large))).toList(),
                      onTap: (index) {
                        widget.onDestinationSelected(index);
                      },
                    ),
                  ),
                  if (widget.header != null) widget.header,
                ],
              ),
            );
          },
          content: widget.body,
        );
      },
    );
  }
}
