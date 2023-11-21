part of 'order_bloc.dart';

class OrderState {

  bool isValidateCanPayNow(Customer customer){

    String custGroup = customer?.customerGroup;
    String sapId = customer?.sapId;

    bool isCredit = !custGroup.isNullEmptyOrWhitespace && (custGroup.startsWith("C") || custGroup.startsWith("V"));
    bool isEmployee = !sapId.isNullEmptyOrWhitespace && sapId.startsWith('EN');
    bool isVat = !(customer?.vatClassification ?? true);

    return !(isCredit || isEmployee || isVat);
  }
}

class InitialOrderState extends OrderState {}

class ShowCustomerInfoState extends OrderState  {

  // Flag for back step
  final String backStepFlag;
  //Back To Customer Receive
  final bool customerReceiveValue;

  ShowCustomerInfoState({this.backStepFlag, this.customerReceiveValue});

  @override
  String toString() {
    return 'ShowCustomerInfoState';
  }
}

class ShipToSelectedState extends OrderState {
  final Customer shipToCustomer;
  final bool isCustomerReceive;
  final ShippingPointList shippingPointStore;

  ShipToSelectedState({this.shipToCustomer, this.isCustomerReceive, this.shippingPointStore});

  @override
  String toString() {
    return 'ShipToSelectedState{shipToCustomer: $shipToCustomer, isCustomerReceive: $isCustomerReceive, shippingPointStore: $shippingPointStore}';
  }
}

class InquiryQueueCompleteState extends OrderState {

  // Flag for back step
  final String backStepFlag;
  //Back To edit delivery date
  final QueueDataItemDto editDateItem;

  InquiryQueueCompleteState({this.backStepFlag, this.editDateItem});

  @override
  String toString() {
    return 'InquiryQueueCompleteState{backStepFlag: $backStepFlag}';
  }
}

class QueueReservedState extends OrderState {
  @override
  String toString() {
    return 'QueueReservedState';
  }
}

class CalculatePromotionCompleteState extends OrderState {
  @override
  String toString() {
    return 'CalculatePromotionCompleteState';
  }
}

class ErrorOrderState extends OrderState {
  final dynamic error;

  ErrorOrderState({this.error});

  @override
  String toString() {
    return 'ErrorOrderState{error: $error}';
  }
}
