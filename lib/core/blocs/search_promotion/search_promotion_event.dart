part of 'search_promotion_bloc.dart';

class SearchPromotionEvent {

  final ArticleList article;

  SearchPromotionEvent(this.article);

  @override
  String toString() {
    return 'SearchPromotionEvent{article: $article}';
  }
}
