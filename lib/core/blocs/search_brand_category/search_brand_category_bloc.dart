import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';

import '../../app_exception.dart';
import '../../get_it.dart';

part 'search_brand_category_event.dart';

part 'search_brand_category_state.dart';

class SearchBrandCategoryBloc extends Bloc<SearchBrandCategoryEvent, SearchBrandCategoryState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final ApplicationBloc applicationBloc;

  SearchBrandCategoryBloc(this.applicationBloc);

  @override
  SearchBrandCategoryState get initialState => InitialSearchBrandCategoryState();

  @override
  Stream<SearchBrandCategoryState> mapEventToState(SearchBrandCategoryEvent event) async* {
    if (event is SearchCategoryEvent) {
      yield* mapEventSearchCategoryEvent(event);
    }
  }

  Stream<SearchBrandCategoryState> mapEventSearchCategoryEvent(SearchCategoryEvent event) async* {
    try {
      yield LoadingBrandCategoryState();

      var futureGetBrandCategoryRs = _categoryService.getBrandCategory(event.getBrandCategoryRq);
      GetBrandCategoryRs getBrandCategoryRs = await futureGetBrandCategoryRs;

      getBrandCategoryRs.mCH2List?.forEach((mch2) {
        mch2.mCH1CategoryList?.removeWhere((mch1) => !mch1.searchTermList.any((searchTerm) => StringUtil.isNotEmpty(searchTerm.mCHId)));
      });

      yield SearchCategoryState(event.getBrandCategoryRq, getBrandCategoryRs);
    } catch (error, stackTrace) {
      yield ErrorBrandCategoryState(AppException(error, stackTrace: stackTrace));
    }
  }
}
