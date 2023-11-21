import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/app_logger.dart';
import 'package:flutter_store_catalog/ui/views/web/basket.dart';
import 'package:flutter_store_catalog/ui/views/web/brand.dart';
import 'package:flutter_store_catalog/ui/views/web/brands.dart';
import 'package:flutter_store_catalog/ui/views/web/category.dart';
import 'package:flutter_store_catalog/ui/views/web/checklist.dart';
import 'package:flutter_store_catalog/ui/views/web/home.dart';
import 'package:flutter_store_catalog/ui/views/web/room.dart';
import 'package:flutter_store_catalog/ui/widgets/knowledge.dart';
import 'package:flutter_store_catalog/ui/views/web/order.dart';
import 'package:flutter_store_catalog/ui/views/web/product.dart';
import 'package:flutter_store_catalog/ui/views/web/products.dart';
import 'package:flutter_store_catalog/ui/views/web/rooms.dart';
import 'package:flutter_store_catalog/ui/views/web/splash.dart';
import 'package:flutter_store_catalog/ui/views/web/salesguide.dart';

class RoutePaths {
  static const String Splash = '/';
  static const String Home = '/home';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

class WebRoutePaths {
  static const String Splash = '/';
  static const String Home = '/home';
  static const String Brands = '/brands';
  static const String Rooms = '/rooms';
  static const String Basket = '/basket';
  static const String Category = '/category';
  static const String Brand = '/brand';
  static const String Room = '/room';
  static const String Products = '/products';
  static const String Product = '/product';
  static const String Order = '/order';
  static const String Knowledge = '/knowledge';
  static const String CheckList = '/checklist';
  static const String SalesGuide = '/salesguide';
}

class WebRouter {
  static AppLogger log = AppLogger();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> arguments = new Map<String, dynamic>.from(settings.arguments ?? {});
    log.d('route name : ${settings.name} | arguments : $arguments');
    switch (settings.name) {
      case WebRoutePaths.Splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashPage(),
        );
      case WebRoutePaths.Home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomePage(isGoToCategoryTab: arguments['isGoToCategoryTab'] ?? false),
        );
      case WebRoutePaths.Brands:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BrandsPage(),
        );
      case WebRoutePaths.Rooms:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RoomsPage(),
        );
      case WebRoutePaths.Basket:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BasketPage(),
        );
      case WebRoutePaths.Category:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CategoryPage(mch3: arguments['mch3'], backgroundColor: arguments['backgroundColor']),
        );
      case WebRoutePaths.Brand:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BrandPage(brand: arguments['brand']),
        );
      case WebRoutePaths.Products:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductsPage(
            mch2: arguments['mch2'],
            mch1: arguments['mch1'],
            brandId: arguments['brandId'],
            searchText: arguments['searchText'],
            calculatorRs: arguments['calculatorRs'],
          ),
        );
      case WebRoutePaths.Product:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductPage(article: arguments['article']),
        );
      case WebRoutePaths.Order:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OrderPage(salesCartOid: arguments['salesCartOid']),
        );
      case WebRoutePaths.Knowledge:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => KnowledgePage(backgroundColor: arguments['backgroundColor'], knowledge: arguments['knowledge']),
        );
      case WebRoutePaths.CheckList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CheckListPage(article: arguments['article']),
        );
      case WebRoutePaths.SalesGuide:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SalesGuidePage(mch: arguments['mch'], knowledgeIdList: arguments['knowledgeIdList'], calculatorId: arguments['calculatorId']),
        );
      case WebRoutePaths.Room:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RoomPage(roomSelected: arguments['roomSelected'], backgroundColor: arguments['backgroundColor']),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
