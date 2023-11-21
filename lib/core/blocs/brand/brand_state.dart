part of 'brand_bloc.dart';

@immutable
abstract class BrandState {
}

class InitialBrandState extends BrandState {}

class LoadingBrandState extends BrandState {
}

class ErrorBrandState extends BrandState {
  final dynamic error;

  ErrorBrandState(this.error);

  @override
  String toString() {
    return 'ErrorBrandState{error: $error}';
  }
}

class BrandLoadSuccessState extends BrandState {

  final Map<String, List<BrandList>> mapBrandSelectionFirstRow;
  final Map<String, List<BrandList>> mapBrandSelectionSecondRow;
  final List<String> brandSelections;
  final Map<String, List<BrandList>> mapBrandResult;

  BrandLoadSuccessState({this.mapBrandSelectionFirstRow, this.mapBrandSelectionSecondRow, this.brandSelections, this.mapBrandResult});
}
