part of 'compare_product_bloc.dart';

@immutable
abstract class CompareProductEvent {}

class AddProductCompareEvent extends CompareProductEvent{
  final ArticleList article;

  AddProductCompareEvent(this.article);
}

class RemoveProductCompareEvent extends CompareProductEvent {
  final num index;

  RemoveProductCompareEvent(this.index);
}

class RemoveAllProductCompareEvent extends CompareProductEvent {}
