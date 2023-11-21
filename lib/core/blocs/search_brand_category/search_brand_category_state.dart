part of 'search_brand_category_bloc.dart';

@immutable
abstract class SearchBrandCategoryState {}

class InitialSearchBrandCategoryState extends SearchBrandCategoryState {
  @override
  String toString() {
    return 'InitialSearchBrandCategoryState{}';
  }
}

class SearchCategoryState extends SearchBrandCategoryState {
  final GetBrandCategoryRq getBrandCategoryRq;
  final GetBrandCategoryRs getBrandCategoryRs;

  SearchCategoryState(this.getBrandCategoryRq, this.getBrandCategoryRs);

  @override
  String toString() {
    return 'SearchCategoryState{getBrandCategoryRq: $getBrandCategoryRq, getBrandCategoryRs: $getBrandCategoryRs';
  }
}

class LoadingBrandCategoryState extends SearchBrandCategoryState {
  @override
  String toString() {
    return 'LoadingBrandCategoryState{}';
  }
}

class ErrorBrandCategoryState extends SearchBrandCategoryState {
  final error;

  ErrorBrandCategoryState(this.error);

  @override
  String toString() {
    return 'ErrorBrandCategoryState{error: $error}';
  }
}
