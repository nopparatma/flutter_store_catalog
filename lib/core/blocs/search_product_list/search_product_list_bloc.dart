import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_filter_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/services/dotnet/article_service.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart' as collection;
import '../../app_exception.dart';
import '../../get_it.dart';

part 'search_product_list_event.dart';

part 'search_product_list_state.dart';

class SearchProductListBloc extends Bloc<SearchProductListEvent, SearchProductListState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final ArticleService _articleService = getIt<ArticleService>();
  final ApplicationBloc applicationBloc;

  SearchProductListBloc(this.applicationBloc);

  @override
  SearchProductListState get initialState => InitialSearchProductListState();

  @override
  Stream<SearchProductListState> mapEventToState(SearchProductListEvent event) async* {
    if (event is SearchMchProductItemEvent) {
      yield* mapEventSearchMchProductItem(event);
    } else if (event is SearchMchProductItemFilterEvent) {
      yield* mapEventSearchMchProductItemFilter(event);
    }
  }

  Stream<SearchProductListState> mapEventSearchMchProductItem(SearchMchProductItemEvent event) async* {
    try {
      yield LoadingProductItemState();

      GetArticleRq getArticleRq = GetArticleRq();

      getArticleRq.startRow = 0;
      getArticleRq.pageSize = event.getArticleRq.pageSize ?? 1;
      getArticleRq.storeId = applicationBloc.state.appSession?.userProfile?.storeId;

      if (!StringUtil.isNullOrEmpty(event.getArticleRq.desc)) {
        getArticleRq.desc = event.getArticleRq.desc;
      }

      getArticleRq.minPrice = event.getArticleRq.minPrice;
      getArticleRq.maxPrice = event.getArticleRq.maxPrice;
      getArticleRq.mCHList = event.getArticleRq.mCHList;
      getArticleRq.brandList = event.getArticleRq.brandList;
      getArticleRq.featureList = event.getArticleRq.featureList;

      var futureGetArticleRs = _categoryService.getArticlePaging(getArticleRq);
      var futureGetArticleFilterRs = _categoryService.getArticleFilter(getArticleRq);

      await Future.wait([
        futureGetArticleRs,
        futureGetArticleFilterRs,
      ], eagerError: true);

      GetArticleRs getArticleRs = await futureGetArticleRs;
      GetArticleFilterRs getArticleFilterRs = await futureGetArticleFilterRs;

      // Get ProductGuide
      GetProductGuideRs getProductGuideRs = await getProductGuide(getArticleFilterRs);

      // sort
      getArticleFilterRs?.brandList?.sort((a, b) {
        return collection.compareAsciiLowerCaseNatural(a.brandId, b.brandId);
      });
      getArticleFilterRs?.categoryList?.sort((a, b) {
        return collection.compareAsciiLowerCaseNatural(a.categoryTH, b.categoryTH);
      });
      getArticleFilterRs?.featureList?.sort((a, b) {
        return collection.compareAsciiLowerCaseNatural(a.featureNameTH, b.featureNameTH);
      });
      getArticleFilterRs?.featureList?.forEach((e) {
        e.featureDescList?.sort((a, b) {
          return collection.compareAsciiLowerCaseNatural(a.featureDescTH, b.featureDescTH);
        });
      });
      getProductGuideRs?.grouping?.sort((a, b) {
        return collection.compareAsciiLowerCaseNatural(a.groupNameTh, b.groupNameTh);
      });

      yield SearchMchProductItemState(getArticleRq, getArticleRs, getArticleFilterRs, getProductGuideRs);
    } catch (error, stackTrace) {
      yield ErrorMchProductItemState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<SearchProductListState> mapEventSearchMchProductItemFilter(SearchMchProductItemFilterEvent event) async* {
    try {
      yield LoadingProductItemState();
      GetArticleRq oldGetArticleRq = event.getArticleRq;

      GetArticleRq getArticleRq = new GetArticleRq();

      getArticleRq.startRow = 0;
      getArticleRq.pageSize = oldGetArticleRq.pageSize ?? 1;
      getArticleRq.storeId = applicationBloc.state.appSession?.userProfile?.storeId;

      getArticleRq.desc = oldGetArticleRq.desc;
      getArticleRq.minPrice = oldGetArticleRq.minPrice;
      getArticleRq.maxPrice = oldGetArticleRq.maxPrice;
      getArticleRq.category = oldGetArticleRq.category;
      getArticleRq.brandList = oldGetArticleRq.brandList;
      getArticleRq.mCHList = oldGetArticleRq.mCHList;
      getArticleRq.featureList = oldGetArticleRq.featureList;
      getArticleRq.sortList = oldGetArticleRq.sortList;

      var futureGetArticleRs = _categoryService.getArticlePaging(getArticleRq);
      var futureGetArticleFilterRs = _categoryService.getArticleFilter(getArticleRq);

      await Future.wait([
        futureGetArticleRs,
        futureGetArticleFilterRs,
      ], eagerError: true);

      GetArticleRs getArticleRs = await futureGetArticleRs;
      GetArticleFilterRs getArticleFilterRs = await futureGetArticleFilterRs;

      // Get ProductGuide
      GetProductGuideRs getProductGuideRs = await getProductGuide(getArticleFilterRs);

      yield SearchMchProductItemFilterState(getArticleRq, getArticleRs, oldGetArticleRq, event.getArticleFilterRs, getProductGuideRs);
    } catch (error, stackTrace) {
      yield ErrorMchProductItemState(AppException(error, stackTrace: stackTrace));
    }
  }

  Future<GetProductGuideRs> getProductGuide(GetArticleFilterRs getArticleFilterRs) async {
    GetProductGuideRq getProductGuideRq = GetProductGuideRq();
    List<String> listMchId = [];
    getArticleFilterRs?.categoryList?.forEach((e) => e.searchTermList?.forEach((f) => listMchId.add(f.mchId)));
    getProductGuideRq.mCHList = listMchId?.toSet()?.toList() ?? [];
    GetProductGuideRs getProductGuideRs = await _articleService.getProductGuide(getProductGuideRq);

    return getProductGuideRs;
  }
}
