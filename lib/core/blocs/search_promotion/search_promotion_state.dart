part of 'search_promotion_bloc.dart';

@immutable
abstract class SearchPromotionState {}

class InitialSearchPromotionState extends SearchPromotionState {}

class LoadingSearchPromotionState extends SearchPromotionState {}

class ErrorSearchPromotionState extends SearchPromotionState {
  final dynamic error;

  ErrorSearchPromotionState(this.error);

  @override
  String toString() {
    return 'ErrorSearchPromotionState{error: $error}';
  }
}

class SearchPromotionSuccessState extends SearchPromotionState {

  final List<Promotions> searchPromotions;

  SearchPromotionSuccessState(this.searchPromotions);

  @override
  String toString() {
    return 'SearchPromotionSuccessState{searchPromotions: $searchPromotions}';
  }
}