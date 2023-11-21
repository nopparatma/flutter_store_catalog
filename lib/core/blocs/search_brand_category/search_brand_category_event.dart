part of 'search_brand_category_bloc.dart';

@immutable
abstract class SearchBrandCategoryEvent {}

class SearchCategoryEvent extends SearchBrandCategoryEvent {
  final GetBrandCategoryRq getBrandCategoryRq;
  final GetBrandCategoryRs getBrandCategoryRs;

  SearchCategoryEvent(this.getBrandCategoryRq, this.getBrandCategoryRs);

  @override
  String toString() {
    return 'SearchCategoryEvent{getBrandCategoryRq: $getBrandCategoryRq, getBrandCategoryRs: $getBrandCategoryRs}';
  }
}
