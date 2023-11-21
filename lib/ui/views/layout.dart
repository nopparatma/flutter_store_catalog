import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_keyboard/flag_keyboard_bloc.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_vertical_divider.dart';
import 'package:flutter_store_catalog/ui/widgets/search_product_panel.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CommonLayout extends StatefulWidget {
  final Widget body;
  final ValueChanged<int> onDestinationSelected;
  final Function onHome;
  final Function onBack;
  final bool isShowBack;
  final bool isShowBasket;
  final bool isShowSearch;
  final Color bodyBackgroundColor;

  CommonLayout({
    Key key,
    this.body,
    this.onDestinationSelected,
    this.onHome,
    this.onBack,
    this.isShowBack = false,
    this.isShowBasket = true,
    this.isShowSearch = true,
    this.bodyBackgroundColor,
  }) : super(key: key);

  @override
  _CommonLayoutState createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  static final double navigationSize = AppBar().preferredSize.height + 10;

  final List<NavigationDestination> destinations = [
    NavigationDestination(icon: Icons.dashboard, label: 'text.menu_category'),
    NavigationDestination(icon: Icons.local_offer, label: 'text.menu_brand'),
    NavigationDestination(icon: MdiIcons.homeFloorA, label: 'text.menu_room'),
  ];

  @override
  void initState() {
    super.initState();
  }

  void onBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void onHome() {
    Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false);
  }

  void onBasket() {
    Navigator.pushNamed(context, WebRoutePaths.Basket);
  }

  void onDefaultDestinationSelected(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false, arguments: {'isGoToCategoryTab': true});
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Brands, (route) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Rooms, (route) => false);
    }
  }

  void onSearch() async {
    await DialogUtil.showCustomDialog(
      context,
      child: SearchProductPanel(),
      backgroundColor: Colors.transparent,
      isShowCloseButton: false,
      barrierDismissible: true,
      elevation: 0,
    );
  }

  void onLanguage() {
    if (LanguageUtil.isTh(context)) {
      context.locale = Locale('en');
    } else {
      context.locale = Locale('th');
    }
  }

  void onAdmin() async {
    await DialogUtil.showCustomDialog(
      context,
      child: AdminPanel(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bodyBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _buildNavigationBar(),
            if (widget.isShowBasket) _buildBasket(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(width: navigationSize),
            Expanded(child: widget.body),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Material(
              color: Colors.grey[100],
              child: SizedBox(
                width: navigationSize,
                child: Column(
                  children: [
                    if (widget.isShowBack)
                      InkWell(
                        onTap: widget.onBack ?? onBack,
                        child: Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.west),
                            ],
                          ),
                        ),
                      ),
                    Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                            image: AssetImage('assets/images/navi_home.png'),
                          ),
                        ),
                        child: InkWell(
                          onTap: widget.onHome ?? onHome,
                          child: Container(
                            padding: EdgeInsets.only(top: 48, bottom: 48),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.home, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          primary: false,
                          itemCount: destinations.length + 1,
                          itemBuilder: (context, index) {
                            if (index == destinations.length) {
                              // search
                              if (!widget.isShowSearch) return Container();

                              return _buildNavigationDestination(
                                icon: Icon(Icons.search),
                                label: Text(
                                  'text.menu_search'.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.smaller,
                                ),
                                onTap: onSearch,
                              );
                            }

                            return _buildNavigationDestination(
                              icon: Icon(destinations[index].icon),
                              label: Text(
                                destinations[index].label.tr(namedArgs: {"newLine": "\n"}),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.smaller,
                              ),
                              onTap: () {
                                if (widget.onDestinationSelected != null) {
                                  widget.onDestinationSelected(index);
                                } else {
                                  onDefaultDestinationSelected(index);
                                }
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(height: 1, thickness: 1);
                          },
                        ),
                      ),
                    ),
                    Divider(height: 1, thickness: 1),
                    _buildBottomMenu(),
                  ],
                ),
              ),
            ),
            // VerticalDivider(thickness: 1, width: 1),
            CustomVericalDivider(),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomMenu() {
    return Column(
      children: [
        _buildNavigationDestination(
          icon: CircleAvatar(
            radius: 12,
            backgroundImage: LanguageUtil.isTh(context) ? AssetImage('assets/images/th-flag.png') : AssetImage('assets/images/usa-flag.png'),
          ),
          label: FittedBox(
            child: Text(
              'common.language'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.smaller,
            ),
          ),
          onTap: onLanguage,
        ),
        _buildNavigationDestination(
          label: Text(
            'text.menu_admin'.tr(namedArgs: {"newLine": "\n"}),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.smaller,
          ),
          onTap: onAdmin,
        ),
      ],
    );
  }

  Widget _buildNavigationDestination({Widget icon, Widget label, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) icon,
            if (label != null) label,
          ],
        ),
      ),
    );
  }

  String getBadgeCount(int number) {
    if (number == null) return '';
    if (number < 10) return ' $number '; // add space for display
    if (number > 99) return '99+';
    return number.toString();
  }

  Widget _buildBasket() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.only(right: 32),
        width: 200,
        height: 72,
        color: Colors.transparent,
        child: BlocBuilder<BasketBloc, BasketState>(
          condition: (previous, current) => current is! ErrorBasketState,
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(8),
                  bottomRight: const Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorGrey1,
                    blurRadius: 4.0,
                    offset: Offset(0, 2.5),
                  ),
                ],
              ),
              child: Badge(
                position: BadgePosition.topEnd(top: 24, end: -14),
                badgeContent: Text(
                  getBadgeCount(state.calculatedItems.length),
                  style: TextStyle(color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(8),
                    bottomRight: const Radius.circular(8),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: onBasket,
                      child: Column(
                        children: [
                          Ink(
                            height: 8,
                            color: colorDark,
                          ),
                          Expanded(
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [colorOrangeGradient1, colorOrangeGradient2],
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ListTile(
                                    mouseCursor: MouseCursor.defer,
                                    horizontalTitleGap: 8,
                                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                                    dense: true,
                                    leading: Ink(
                                      padding: EdgeInsets.all(8),
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorDark,
                                      ),
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(pi),
                                        child: Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    title: Text.rich(
                                      TextSpan(
                                        text: StringUtil.getDefaultCurrencyFormat(state.unpaidAmt),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(text: ' ${'text.baht'.tr()}', style: TextStyle(fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    subtitle: Text(
                                      'text.view_cart'.tr(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  AppSession appSession;
  bool isEnabledKeyboard;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    if (!mounted) return;

    appSession = BlocProvider.of<ApplicationBloc>(context).state.appSession;
    isEnabledKeyboard = BlocProvider.of<FlagKeyboardBloc>(context)?.state?.isEnabled ?? false;

    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  onLogout() {
    Navigator.of(context).pop();
  }

  onPressedToggleEnableKeyboard() {
    BlocProvider.of<FlagKeyboardBloc>(context)..add(ToggleFlagKeyboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'common.version'.tr(args: ['']),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            '${_packageInfo?.version} build ${_packageInfo.buildNumber}',
            style: Theme.of(context).textTheme.small,
          ),
        ),
        Divider(height: 1, thickness: 1),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'common.employeeid'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            '${appSession?.userProfile?.empId}',
            style: Theme.of(context).textTheme.small,
          ),
        ),
        Divider(height: 1, thickness: 1),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'common.name'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            '${appSession?.userProfile?.empName}',
            style: Theme.of(context).textTheme.small,
          ),
        ),
        Divider(height: 1, thickness: 1),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'text.trans_date'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            appSession?.transactionDateTime != null ? DateTimeUtil.toDateTimeString(appSession?.transactionDateTime, 'dd/MM/yyyy') : '',
            style: Theme.of(context).textTheme.small,
          ),
        ),
        Divider(height: 1, thickness: 1),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'text.trans_store'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            '${appSession?.userProfile?.storeId} - ${appSession?.userProfile?.storeDesc}',
            style: Theme.of(context).textTheme.small,
          ),
        ),
        // Divider(height: 1, thickness: 1),
        // ListTile(
        //   contentPadding: EdgeInsets.all(0),
        //   title: Text(
        //     'text.display_keyboard'.tr(),
        //     style: Theme.of(context).textTheme.normal.copyWith(
        //           fontWeight: FontWeight.bold,
        //         ),
        //   ),
        //   subtitle: BlocBuilder<FlagKeyboardBloc, FlagKeyboardState>(
        //     builder: (context, state) {
        //       if (state is FlagKeyboardState) {
        //         isEnabledKeyboard = state.isEnabled;
        //       }
        //
        //       return Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 6.0),
        //             child: FlutterSwitch(
        //               activeText: ' ${'text.active'.tr()}',
        //               activeColor: colorBlue7,
        //               activeTextFontWeight: FontWeight.normal,
        //               activeTextColor: Colors.white,
        //               inactiveText: '${'text.inactive'.tr()} ',
        //               inactiveTextFontWeight: FontWeight.normal,
        //               inactiveTextColor: Colors.white,
        //               valueFontSize: Theme.of(context).textTheme.normal.fontSize,
        //               width: 120,
        //               borderRadius: 20.0,
        //               showOnOff: true,
        //               value: isEnabledKeyboard,
        //               onToggle: (val) {
        //                 onPressedToggleEnableKeyboard();
        //               },
        //             ),
        //           ),
        //         ],
        //       );
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextButton(
        //     onPressed: onLogout,
        //     child: Text(
        //       'common.logout'.tr(),
        //       style: TextStyle(
        //         decoration: TextDecoration.underline,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class NavigationDestination {
  final IconData icon;
  final String label;

  NavigationDestination({this.icon, this.label});
}
