part of 'search_product_list_bloc.dart';

@immutable
abstract class SearchProductListEvent {}

class SearchMchProductItemEvent extends SearchProductListEvent {
  final GetArticleRq getArticleRq;
  final GetArticleRs getArticleRs;
  final GetArticleFilterRs getArticleFilterRs;

  SearchMchProductItemEvent(this.getArticleRq, this.getArticleRs, this.getArticleFilterRs);

  @override
  String toString() {
    return 'SearchMchProductItemEvent{getArticleRq: $getArticleRq, getArticleRs: $getArticleRs, getArticleFilterRs: $getArticleFilterRs}';
  }
}

class SearchMchProductItemFilterEvent extends SearchProductListEvent {
  final GetArticleRq getArticleRq;
  final GetArticleFilterRs getArticleFilterRs;

  SearchMchProductItemFilterEvent(this.getArticleRq, this.getArticleFilterRs);

  @override
  String toString() {
    return 'SearchMchProductItemFilterEvent{getArticleRq: $getArticleRq, getArticleFilterRs: $getArticleFilterRs}';
  }
}
