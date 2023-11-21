part of 'search_product_compare_bloc.dart';

@immutable
abstract class ProductCompareSearchEvent {}

class SearchProductCompareEvent extends ProductCompareSearchEvent {
  final List<ArticleList> articleList;

  SearchProductCompareEvent(this.articleList);

  @override
  String toString() {
    return 'SearchProductCompareEvent{articleList: $articleList}';
  }
}