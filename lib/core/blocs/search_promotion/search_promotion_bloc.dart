import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/promotion_bkoffc_service.dart';
import 'package:meta/meta.dart';

part 'search_promotion_event.dart';

part 'search_promotion_state.dart';

class SearchPromotionBloc extends Bloc<SearchPromotionEvent, SearchPromotionState> {
  final PromotionBkoffcService _promotionService = getIt<PromotionBkoffcService>();

  final ApplicationBloc applicationBloc;

  SearchPromotionBloc(this.applicationBloc);

  @override
  SearchPromotionState get initialState => InitialSearchPromotionState();

  @override
  Stream<SearchPromotionState> mapEventToState(SearchPromotionEvent event) async* {
    try {
      yield LoadingSearchPromotionState();

      AppSession appSession = applicationBloc.state.appSession;

      if (event.article == null) {
        yield SearchPromotionSuccessState(<Promotions>[]);
        return;
      }

      SearchPromotionRq searchPromotionRq = SearchPromotionRq();
      searchPromotionRq.storeId = appSession.userProfile.storeId;
      searchPromotionRq.startRow = 0;
      searchPromotionRq.pagesize = 0;
      searchPromotionRq.articleNo = event.article.articleId;
      searchPromotionRq.unit = event.article.unitList[0].unit;

      SearchPromotionRs searchPromotionRs = await _promotionService.searchPromotion(appSession, searchPromotionRq);

      yield SearchPromotionSuccessState(searchPromotionRs.promotions);
    } catch (error, stackTrace) {
      yield ErrorSearchPromotionState(AppException(error, stackTrace: stackTrace));
    }

  }
}
