part of 'category_bloc.dart';

@immutable
abstract class CategoryState {
}

class InitialCategoryState extends CategoryState {}

class LoadingCategoryState extends CategoryState {
}

class ErrorCategoryState extends CategoryState {
  final dynamic error;

  ErrorCategoryState(this.error);

  @override
  String toString() {
    return 'ErrorCategoryState{error: $error}';
  }
}

class CategoryLoadSuccessState extends CategoryState {

  @override
  String toString() {
    return 'CategoryLoadSuccessState{}';
  }
}
