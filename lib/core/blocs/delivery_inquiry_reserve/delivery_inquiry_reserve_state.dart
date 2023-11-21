part of 'delivery_inquiry_reserve_bloc.dart';

@immutable
abstract class DeliveryInquiryReserveState {}

class InitialDeliveryInquiryReserveState extends DeliveryInquiryReserveState {
  List<QueueData> queueDataList;

  InitialDeliveryInquiryReserveState({this.queueDataList});
}

class DeliveryInquiryReserveLoadingState extends DeliveryInquiryReserveState {
  @override
  String toString() => 'DeliveryInquiryReserveLoadingState';
}

class InquiryQueueSuccessState extends DeliveryInquiryReserveState {
  final bool needInitial;
  final bool canReserveSameDay;
  final bool isHaveFreeServiceQueue;
  final bool isAllCanReserve;

  InquiryQueueSuccessState({this.needInitial = true, this.canReserveSameDay = true, this.isAllCanReserve = true, this.isHaveFreeServiceQueue = false});

  @override
  String toString() {
    return 'InquiryQueueSuccessState{needInitial: $needInitial, canReserveSameDay: $canReserveSameDay, isHaveFreeServiceQueue: $isHaveFreeServiceQueue, isAllCanReserve: $isAllCanReserve}';
  }
}

class InquiryQueueSelectDaySuccessState extends DeliveryInquiryReserveState {
  final QueueDataItemDto queueDataItemDto;

  InquiryQueueSelectDaySuccessState(this.queueDataItemDto);

  @override
  String toString() {
    return 'InquiryQueueSelectDaySuccessState{}';
  }
}

class CalculateDeliveryFeeSuccessState extends DeliveryInquiryReserveState {

  CalculateDeliveryFeeSuccessState();

  @override
  String toString() {
    return 'CalculateDeliveryFeeSuccessState{}';
  }
}

class InquiryQueueErrorState extends DeliveryInquiryReserveState {
  final error;
  final String errorMsg;

  InquiryQueueErrorState(this.error, {this.errorMsg});

  @override
  String toString() => 'InquiryQueueErrorState{error: $error}';
}

class InquiryQueueSelectDateErrorState extends DeliveryInquiryReserveState {
  final error;
  final String errorMsg;

  InquiryQueueSelectDateErrorState(this.error, {this.errorMsg});

  @override
  String toString() => 'InquiryQueueSelectDateErrorState{error: $error}';
}

class ReserveQueueSuccessState extends DeliveryInquiryReserveState {
  @override
  String toString() {
    return 'ReserveQueueSuccessState{}';
  }
}

class ReserveQueueErrorState extends DeliveryInquiryReserveState {
  final error;

  ReserveQueueErrorState(this.error);

  @override
  String toString() => 'ReserveQueueErrorState{error: $error}';
}

class ServiceAreaNotFoundState extends DeliveryInquiryReserveState {
  ServiceAreaNotFoundState();

  @override
  String toString() {
    return 'ServiceAreaNotFoundState{}';
  }
}
