part of 'brand_bloc.dart';

@immutable
abstract class BrandEvent {}

class SearchBrandEvent extends BrandEvent {
  final String searchText;

  SearchBrandEvent(this.searchText);
}