part of 'shipping_point_store_bloc.dart';

@immutable
abstract class ShippingPointStoreState {}

class InitialShippingPointStoreState extends ShippingPointStoreState {}

class LoadingShippingPointStoreState extends ShippingPointStoreState {
  @override
  String toString() {
    return 'LoadingShippingPointStoreState';
  }
}

class ErrorShippingPointStoreState extends ShippingPointStoreState {
  final dynamic error;

  ErrorShippingPointStoreState({this.error});

  @override
  String toString() {
    return 'ErrorShippingPointStoreState{error: $error}';
  }
}

class SuccessSearchShippingPointStoreState extends ShippingPointStoreState {
  final List<ShippingPointList> lstShippingPointStore;
  final List<StoreZone> listOptionsZone;

  SuccessSearchShippingPointStoreState({this.lstShippingPointStore, this.listOptionsZone});

  @override
  String toString() {
    return 'SuccessShippingPointStoreState{lstShippingPointStore: $lstShippingPointStore, listOptionsZone: $listOptionsZone}';
  }
}

class SuccessFilterShippingPointStoreState extends ShippingPointStoreState {
  final List<ShippingPointList> lstShippingPointStoreFilter;

  SuccessFilterShippingPointStoreState({this.lstShippingPointStoreFilter});

  @override
  String toString() {
    return 'SuccessFilterShippingPointStoreState{lstShippingPointStoreFilter: $lstShippingPointStoreFilter}';
  }
}
