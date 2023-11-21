part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class SearchCategoryEvent extends CategoryEvent {

  @override
  String toString() {
    return 'SearchCategoryEvent{}';
  }
}