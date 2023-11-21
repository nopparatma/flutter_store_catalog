import 'dart:async';
import 'dart:io';

import 'package:catcher/core/catcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_store_catalog/core/app_logger.dart';
import 'package:flutter_store_catalog/core/blocs/app_timer/app_timer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/checklist_information/checklist_information_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/compare_product/compare_product_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/consent_policy/consent_policy_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/create_customer/create_customer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_compare/flag_compare_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_keyboard/flag_keyboard_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/splash_web_load/splash_web_load_bloc.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/ui_config.dart';
import 'package:flutter_store_catalog/ui/views/web/splash.dart';
import 'package:flutter_store_catalog/ui/widgets/dialog_session_time_out.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import '../ui/router.dart';
import '../ui/widgets/csv_asset_loader.dart';
import 'app_config.dart';

class MainAppLocalization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationBloc>(
          create: (context) => ApplicationBloc(),
        ),
        BlocProvider<AppTimerBloc>(
          create: (context) => AppTimerBloc(ticker: Ticker()),
        ),
        BlocProvider<SplashWebLoadBloc>(
          create: (context) => SplashWebLoadBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<SalesCartBloc>(
          create: (context) => SalesCartBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<AppTimerBloc>(context), BlocProvider.of<SalesCartBloc>(context)),
        ),
        BlocProvider<ConsentPolicyBloc>(
          create: (context) => ConsentPolicyBloc(BlocProvider.of<ApplicationBloc>(context)),
        ),
        BlocProvider<CompareProductBloc>(
          create: (context) => CompareProductBloc(),
        ),
        BlocProvider<FlagCompareBloc>(
          create: (context) => FlagCompareBloc(),
        ),
        BlocProvider<FlagKeyboardBloc>(
          create: (context) => FlagKeyboardBloc()..add(LoadFlagKeyboardEvent()),
        ),
      ],
      child: EasyLocalization(
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 1,
          overlayWidget: buildOverlayLoader(),
          child: buildChild(),
        ),
        supportedLocales: [
          Locale('th'),
          Locale('en'),
        ],
        path: 'assets/langs/langs.csv',
        assetLoader: CsvAssetLoader(),
        useOnlyLangCode: true,
        fallbackLocale: Locale('th'),
        startLocale: Locale('th'),
      ),
    );
  }

  buildChild() {
    if (kIsWeb) {
      return MainWeb();
    } else if (Platform.isAndroid || Platform.isIOS) {
      return MainApp();
    }
  }

  Widget buildOverlayLoader() {
    return Expanded(
      child: Container(
        color: colorBlue2.withOpacity(0.6),
        child: Center(
          child: Container(
            height: 64,
            width: 64,
            child: ColoredCircularProgressIndicator(strokeWidth: 8),
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MainWeb extends StatefulWidget {
  @override
  _MainWebState createState() => _MainWebState();
}

class _MainWebState extends State<MainWeb> {
  String token;

  @override
  void initState() {
    print('Uri.base.toString ${Uri.base.toString()}');
    print('Uri.base.query ${Uri.base.query}');
    print('token ${Uri.base.queryParameters['token']}');
    token = Uri.base.queryParameters['token'];
    super.initState();
  }

  Future<void> _resetSessionTimer([_]) async {
    if ((BlocProvider.of<BasketBloc>(context).state.isFoundArticle() || BlocProvider.of<SalesCartBloc>(context).state?.salesCartDto?.salesCart?.customer != null) && BlocProvider.of<AppTimerBloc>(context).state is! AppTimerRunComplete) {
      BlocProvider.of<AppTimerBloc>(context).add(AppTimerStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetSessionTimer,
      onPanDown: _resetSessionTimer,
      onScaleStart: _resetSessionTimer,
      onTapUp: (detail) => FocusScope.of(context).requestFocus(FocusNode()),
      child: BlocListener<AppTimerBloc, AppTimerState>(
        listener: (context, state) async {
          if (state is AppTimerRunComplete) {
            DialogUtil.hideLoadingDialog(context);

            var isContinue = await DialogUtil.showCustomDialog(
              Catcher.navigatorKey.currentContext,
              isShowCloseButton: false,
              backgroundColor: Colors.white,
              child: DialogSessionTimeOut(),
            );

            if (isContinue ?? false) BlocProvider.of<AppTimerBloc>(Catcher.navigatorKey.currentContext).add(AppTimerStarted());
          }
        },
        child: MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget),
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(1600, name: "HD"),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            // background: Container(color: Color(0xFFF5F5F5)),
            backgroundColor: Colors.white,
          ),
          title: AppConfig.instance.applicationName,
          theme: ThemeData(
            primarySwatch: colorPrimaryTheme,
            accentColor: colorAccent,
            fontFamily: appFontFamily,
            backgroundColor: Colors.white,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: colorDark,
                  displayColor: colorDark,
                  fontFamily: appFontFamily,
                ),
            iconTheme: const IconThemeData(color: colorDark),
            tabBarTheme: TabBarTheme(
              labelStyle: TextStyle(
                fontFamily: appFontFamily,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: appFontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontFamily: appFontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                textStyle: TextStyle(
                  fontFamily: appFontFamily,
                  fontWeight: FontWeight.normal,
                ),

              ),
            )
          ),
          navigatorKey: Catcher.navigatorKey,
          onGenerateRoute: WebRouter.generateRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorObservers: [middleware],
          home: SplashPage(token: token),
        ),
      ),
    );
  }
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
NavigatorMiddleware<Route> middleware = NavigatorMiddleware<Route>();

typedef OnRouteChange<R extends Route<dynamic>> = void Function(R route, R previousRoute);

class NavigatorMiddleware<R extends Route<dynamic>> extends RouteObserver<R> {
  var log = AppLogger();

  NavigatorMiddleware({
    this.enableLogger = true,
    this.onPush,
    this.onPop,
    this.onReplace,
    this.onRemove,
  }) : _stack = [];

  final List<R> _stack;
  final bool enableLogger;

  final OnRouteChange<R> onPush;
  final OnRouteChange<R> onPop;
  final OnRouteChange<R> onReplace;
  final OnRouteChange<R> onRemove;

  //create clone list from stack
  // List<R> get stack => List<R>.from(_stack);

  @override
  void didPush(Route route, Route previousRoute) {
    _logget('{didPush} \n route: $route \n previousRoute: $previousRoute');
    _stack.add(route);
    _logStack();
    if (onPush != null) {
      onPush(route, previousRoute);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    _logget('{didPop} \n route: $route \n previousRoute: $previousRoute');
    _stack.remove(route);
    _logStack();
    if (onPop != null) {
      onPop(route, previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    _logget('{didReplace} \n newRoute: $newRoute \n oldRoute: $oldRoute');
    if (_stack.indexOf(oldRoute) >= 0) {
      final oldItemIndex = _stack.indexOf(oldRoute);
      _stack[oldItemIndex] = newRoute;
    }
    _logStack();
    if (onReplace != null) {
      onReplace(newRoute, oldRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    _logget('{didRemove} \n route: $route \n previousRoute: $previousRoute');
    _stack.remove(route);
    _logStack();
    if (onRemove != null) {
      onRemove(route, previousRoute);
    }
    super.didRemove(route, previousRoute);
  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    _logget('{didStartUserGesture} \n route: $route \n previousRoute: $previousRoute');
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    _logget('{didStopUserGesture}');
    super.didStopUserGesture();
  }

  void _logStack() {
    final mappedStack = _stack.map((Route route) => route.settings.name).toList();

    _logget('Navigator stack: $mappedStack');
  }

  void _logget(String content) {
    if (enableLogger) {
      log.d(content);
    }
  }
}
