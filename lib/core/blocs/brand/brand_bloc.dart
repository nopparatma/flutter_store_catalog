import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final ApplicationBloc applicationBloc;

  BrandBloc(this.applicationBloc);

  @override
  BrandState get initialState => InitialBrandState();

  @override
  Stream<BrandState> mapEventToState(BrandEvent event) async* {
    if (event is SearchBrandEvent) {
      yield* mapEventSearchBrandToState(event);
    }
  }

  Stream<BrandState> mapEventSearchBrandToState(SearchBrandEvent event) async* {
    try {
      yield LoadingBrandState();

      GetBrandRs getBrandRs = applicationBloc.state.getBrandRs;
      if(getBrandRs == null){
        getBrandRs = await _categoryService.getBrand(GetBrandRq());

        getBrandRs.brandList?.sort((a, b) {
          return a.brandId.compareTo(b.brandId);
        });

        applicationBloc.add(ApplicationUpdateStateModelEvent(
          appSession: applicationBloc.state.appSession,
          getBrandRs: getBrandRs,
        ));
      }

      List<BrandList> brandLst = getBrandRs.brandList ?? [];
      Map mapBrandGroup = getMapBrandGroup(brandLst);
      Map<String, List<BrandList>> mapBrandSelectionFirstRow = {}..addAll(mapBrandGroup['mapBrandEng'])..addAll(mapBrandGroup['mapBrandSpecial'])..addAll(mapBrandGroup['mapBrandNumber']);
      Map<String, List<BrandList>> mapBrandSelectionSecondRow = {}..addAll(mapBrandGroup['mapBrandThai']);
      List<String> brandSelections = mapBrandSelectionFirstRow.keys.toList()..addAll(mapBrandSelectionSecondRow.keys.toList());

      Map<String, List<BrandList>> mapBrandResult = filterBrand(brandLst, event.searchText);

      yield BrandLoadSuccessState(
        mapBrandSelectionFirstRow: mapBrandSelectionFirstRow,
        mapBrandSelectionSecondRow: mapBrandSelectionSecondRow,
        brandSelections: brandSelections,
        mapBrandResult: mapBrandResult,
      );
    } catch (error, stackTrace) {
      yield ErrorBrandState(AppException(error, stackTrace: stackTrace));
    }
  }

  Map getMapBrandGroup(List<BrandList> brands) {
    SplayTreeMap<String, List<BrandList>> mapBrandEng = SplayTreeMap<String, List<BrandList>>();
    SplayTreeMap<String, List<BrandList>> mapBrandNumber = SplayTreeMap<String, List<BrandList>>();
    SplayTreeMap<String, List<BrandList>> mapBrandThai = SplayTreeMap<String, List<BrandList>>();
    SplayTreeMap<String, List<BrandList>> mapBrandSpecial = SplayTreeMap<String, List<BrandList>>();
    for (BrandList brand in brands) {
      if (StringUtil.isNullOrEmpty(brand.brandId)) continue;

      String brandGrp = getBrandGroup(brand.brandId);
      if (isEng(brandGrp)) {
        mapBrandEng.putIfAbsent(brandGrp, () => []).add(brand);
      } else if (isNumber(brandGrp)) {
        mapBrandNumber.putIfAbsent(brandGrp, () => []).add(brand);
      } else if (isThaiWithoutVowel(brandGrp)) {
        mapBrandThai.putIfAbsent(brandGrp, () => []).add(brand);
      } else {
        mapBrandSpecial.putIfAbsent(brandGrp, () => []).add(brand);
      }
    }
    return {'mapBrandEng': mapBrandEng, 'mapBrandNumber': mapBrandNumber, 'mapBrandThai': mapBrandThai, 'mapBrandSpecial': mapBrandSpecial};
  }

  Map<String, List<BrandList>> filterBrand(List<BrandList> brandLst, String searchText) {
    searchText = searchText.toUpperCase();
    List<BrandList> filteredBrandList = brandLst;
    if (!StringUtil.isNullOrEmpty(searchText)) {
      filteredBrandList = brandLst.where((e) => e.brandId.toUpperCase().contains(searchText)).toList();
    }
    Map mapBrandGroup = getMapBrandGroup(filteredBrandList);
    return {}..addAll(mapBrandGroup['mapBrandEng'])..addAll(mapBrandGroup['mapBrandSpecial'])..addAll(mapBrandGroup['mapBrandNumber'])..addAll(mapBrandGroup['mapBrandThai']);
  }

  bool isEng(String firstChar) {
    return RegExp(r'[a-zA-Z]').hasMatch(firstChar);
  }

  bool isNumber(String firstChar) {
    return RegExp(r'[0-9]').hasMatch(firstChar);
  }

  bool isThaiWithVowel(String firstChar) {
    return RegExp(r'[\u0E00-\u0E7F]').hasMatch(firstChar);
  }

  bool isThaiWithoutVowel(String firstChar) {
    return RegExp(r'[ก-ฮ]').hasMatch(firstChar);
  }

  String getBrandGroup(String brandId) {
    String firstChar = brandId.substring(0, 1);
    if (isEng(firstChar)) {
      return firstChar.toUpperCase();
    } else if (isNumber(firstChar)) {
      return '0-9';
    } else if (isThaiWithVowel(firstChar)) {
      //thai char
      if (isThaiWithoutVowel(firstChar)) {
        return firstChar;
      }
      for (int i = 1; i < brandId.length; i++) {
        String oneDigitChar = brandId.substring(i, i + 1);
        if (isThaiWithoutVowel(oneDigitChar)) {
          return oneDigitChar;
        }
      }
    }
    return '@#';
  }
}
