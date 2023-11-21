part of 'check_stock_store_bloc.dart';

@immutable
abstract class CheckStockStoreEvent {}

class GetStockStoreEvent extends CheckStockStoreEvent {

  final ArticleList article;

  GetStockStoreEvent(this.article);

  @override
  String toString() {
    return 'GetStockStoreEvent{article: $article}';
  }
}
