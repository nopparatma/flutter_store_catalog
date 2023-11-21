part of 'search_product_compare_bloc.dart';

@immutable
abstract class ProductCompareSearchState {}

class InitialProductCompareSearchState extends ProductCompareSearchState {

  @override
  String toString() {
    return 'InitialProductCompareSearchState{}';
  }
}

class SearchProductCompareState extends ProductCompareSearchState {
  final CompareArticleAttributeRs compareArticleAttributeRs;
  final List<ArticleList> articleList;
  final List<String> mappingIdList;

  SearchProductCompareState({this.compareArticleAttributeRs, this.articleList, this.mappingIdList});

  @override
  String toString() {
    return 'SearchProductCompareState{compareArticleAttributeRs: $compareArticleAttributeRs, articleList: $articleList, mappingIdList: $mappingIdList}';
  }
}

class LoadingProductCompareSearchState extends ProductCompareSearchState {

  @override
  String toString() {
    return 'LoadingProductCompareSearchState{}';
  }
}

class ErrorProductCompareSearchState extends ProductCompareSearchState {
  final error;

  ErrorProductCompareSearchState(this.error);

  @override
  String toString() {
    return 'ErrorProductCompareSearchState{error: $error}';
  }
}