part of 'search_product_list_bloc.dart';

@immutable
abstract class SearchProductListState {}

class InitialSearchProductListState extends SearchProductListState {
  @override
  String toString() {
    return 'InitialMchProductItemState{}';
  }
}

class SearchMchProductItemState extends SearchProductListState {
  final GetArticleRq getArticleRq;
  final GetArticleRs getArticleRs;
  final GetArticleFilterRs getArticleFilterRs;
  final GetProductGuideRs getProductGuideRs;

  SearchMchProductItemState(
    this.getArticleRq,
    this.getArticleRs,
    this.getArticleFilterRs,
    this.getProductGuideRs,
  );

  @override
  String toString() {
    return 'SearchMchProductItemState{getArticleRq: $getArticleRq, getArticleRs: $getArticleRs, getArticleFilterRs: $getArticleFilterRs, getProductGuideRs: $getProductGuideRs}';
  }
}

class SearchMchProductItemFilterState extends SearchProductListState {
  final GetArticleRq getArticleRq;
  final GetArticleRs getArticleRs;
  final GetArticleRq oldGetArticleRq;
  final GetArticleFilterRs getArticleFilterRs;
  final GetProductGuideRs getProductGuideRs;

  SearchMchProductItemFilterState(this.getArticleRq, this.getArticleRs, this.oldGetArticleRq, this.getArticleFilterRs, this.getProductGuideRs);

  @override
  List<Object> get props => [getArticleRq, getArticleRs];

  @override
  String toString() {
    return 'SearchMchProductItemFilterState{getArticleRq: $getArticleRq, getArticleRs: $getArticleRs, oldGetArticleRq: $oldGetArticleRq, getArticleFilterRs: $getArticleFilterRs, getProductGuideRs: $getProductGuideRs}';
  }
}

class LoadingProductItemState extends SearchProductListState {
  @override
  String toString() {
    return 'SearchMchLoadingState{}';
  }
}

class ErrorMchProductItemState extends SearchProductListState {
  final error;

  ErrorMchProductItemState(this.error);

  @override
  String toString() {
    return 'ErrorMchProductItemState{error: $error}';
  }
}
