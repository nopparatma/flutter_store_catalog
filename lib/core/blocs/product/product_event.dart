part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ProductLoadEvent extends ProductEvent{
  final ArticleList article;

  ProductLoadEvent(this.article);

  @override
  String toString() {
    return 'ProductLoadEvent{article: $article}';
  }
}

