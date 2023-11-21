import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final ApplicationBloc applicationBloc;

  CategoryBloc(this.applicationBloc);

  @override
  CategoryState get initialState => InitialCategoryState();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is SearchCategoryEvent) {
      yield* mapEventSearchCategoryToState(event);
    }
  }

  Stream<CategoryState> mapEventSearchCategoryToState(SearchCategoryEvent event) async* {
    try {
      yield LoadingCategoryState();

      if(applicationBloc.state.getCategoryRs == null){
        GetCategoryRs getCategoryRs = await _categoryService.getCategory(GetCategoryRq());

        getCategoryRs.mCH3List?.forEach((mch3) {
          mch3.mCH2List?.forEach((mch2) {
            mch2.mCH1CategoryList?.removeWhere((mch1) => !mch1.searchTermList.any((searchTerm) => StringUtil.isNotEmpty(searchTerm.mCHId)));
          });
        });
        getCategoryRs.mCH3List?.forEach((mch3) {
          mch3.mCH2List?.removeWhere((mch2) => mch2.mCH1CategoryList == null || mch2.mCH1CategoryList.isEmpty);
        });

        applicationBloc.add(ApplicationUpdateStateModelEvent(
          getCategoryRs: getCategoryRs,
        ));
      }
      yield CategoryLoadSuccessState();
    } catch (error, stackTrace) {
      yield ErrorCategoryState(AppException(error, stackTrace: stackTrace));
    }
  }
}
