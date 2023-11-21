part of 'shipping_point_store_bloc.dart';

@immutable
abstract class ShippingPointStoreEvent {}

class SearchShippingPointStoreEvent extends ShippingPointStoreEvent {}

class FilterShippingPointStoreEvent extends ShippingPointStoreEvent {
  final List<ShippingPointList> lstMainShippingPointStore;
  final String region;
  final String name;

  FilterShippingPointStoreEvent({this.lstMainShippingPointStore, this.region, this.name});

  @override
  String toString() {
    return 'FilterShippingPointStoreEvent{lstMainShippingPointStore: $lstMainShippingPointStore, region: $region, name: $name}';
  }
}
