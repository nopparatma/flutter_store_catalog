import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_store_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_store_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/stock_service.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart' as collection;

part 'check_stock_store_event.dart';

part 'check_stock_store_state.dart';

class CheckStockStoreBloc extends Bloc<CheckStockStoreEvent, CheckStockStoreState> {
  final StockService _stockService = getIt<StockService>();

  final ApplicationBloc applicationBloc;

  CheckStockStoreBloc(this.applicationBloc);

  @override
  CheckStockStoreState get initialState => InitialCheckStockStoreState();

  @override
  Stream<CheckStockStoreState> mapEventToState(CheckStockStoreEvent event) async* {
    if (event is GetStockStoreEvent) {
      yield* mapEventGetStockStoreToState(event);
    }
  }

  Stream<CheckStockStoreState> mapEventGetStockStoreToState(GetStockStoreEvent event) async* {
    try {
      yield LoadingCheckStockStoreState();

      AppSession appSession = applicationBloc.state.appSession;

      GetStockStoreRq getStockStoreRq = GetStockStoreRq(
        storeId: appSession.userProfile.storeId,
        sapArticles: []..add(SapArticle(articleNo: event.article.articleId, unit: event.article.unitList?.firstOrNull?.unit)),
      );
      GetStockStoreRs getStockStoreRs = await _stockService.getStockStore(appSession, getStockStoreRq);
      List<StockStores> stockList = getStockStoreRs.stockList.where((element) => (element.stockStoreArticleBos?.firstOrNull?.availableQty ?? 0) > 0).toList();
      bool isThisStoreHaveStock = stockList.any((element) => element.storeId == appSession.userProfile.storeId);
      yield GetStockStoreSuccessState(stockList, isThisStoreHaveStock);
    } catch (error, stackTrace) {
      yield ErrorCheckStockStoreState(AppException(error, stackTrace: stackTrace));
    }
  }
}
