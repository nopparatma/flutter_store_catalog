part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class ShowCustomerInfoToEvent extends OrderEvent {
  @override
  String toString() {
    return 'ShowCustomerInfoToEvent';
  }
}

class BackStepToCustomerPanel extends OrderEvent {
  final String backStepFlag;
  final bool customerReceiveValue;

  BackStepToCustomerPanel({this.backStepFlag, this.customerReceiveValue});

  @override
  String toString() {
    return 'BackStepToCustomerPanel{backStepFlag: $backStepFlag, customerReceiveValue: $customerReceiveValue}';
  }
}

class BackStepToInquiryPanel extends OrderEvent {
  final String backStepFlag;
  final QueueDataItemDto editDateItem;

  BackStepToInquiryPanel({this.backStepFlag, this.editDateItem});

  @override
  String toString() {
    return 'BackStepToInquiryPanel{backStepFlag: $backStepFlag}';
  }
}

class SelectShipToEvent extends OrderEvent {
  final Customer shipToCustomer;
  final bool isCustomerReceive;
  final ShippingPointList shippingPointStore;

  SelectShipToEvent({this.shipToCustomer, this.isCustomerReceive, this.shippingPointStore});

  @override
  String toString() {
    return 'SelectShipToEvent{shipToCustomer: $shipToCustomer, isCustomerReceive: $isCustomerReceive, shippingPointStore: $shippingPointStore}';
  }
}

class InquiryQueueToEvent extends OrderEvent {
  @override
  String toString() {
    return 'InquiryQueueToEvent';
  }
}

class ChangeQueueDateToEvent extends OrderEvent {
  @override
  String toString() {
    return 'ChangeQueueDateToEvent';
  }
}

class OrderReserveQueueEvent extends OrderEvent {
  @override
  String toString() {
    return 'OrderReserveQueueEvent';
  }
}

class AlreadyReservedQueueEvent extends OrderEvent {
  @override
  String toString() {
    return 'AlreadyReservedQueueEvent';
  }
}

class CalPromotionEvent extends OrderEvent {
  @override
  String toString() {
    return 'CalPromotionEvent';
  }
}
