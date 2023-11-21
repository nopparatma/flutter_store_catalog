part of 'delivery_inquiry_reserve_bloc.dart';

@immutable
abstract class DeliveryInquiryReserveEvent {}

class InquiryQueueEvent extends DeliveryInquiryReserveEvent {
  /// กรณีตรวจสอบคิว
  /// * กำหนดเอง
  /// * กำหนด shippoint
  /// * ลูกค้ารับเอง
  final String shippoint;

  // /// กรณีตรวจสอบคิว
  // /// จองคิวกำหนดเอง (store manual)
  // final String deliveryMng;
  // final String jobType;
  // final String mainProductType;

  final SalesCartReserve salesCartReserve;

  InquiryQueueEvent({
    @required this.salesCartReserve,
    this.shippoint,
    // this.deliveryMng,
    // this.jobType,
    // this.mainProductType,
  });
}

class InquiryQueueSelectDateEvent extends DeliveryInquiryReserveEvent {
  final SalesCartReserve salesCartReserve;
  final QueueDataItemDto selectQueueDataItemDto;
  final List<QueueDataItemDto> queueDataItemDtoList;
  final DateTime inquiryDate;

  // final String timeNo;
  // final TopWorker worker;

  /// Flag clear ปฏิทิน
  /// * [true] จะ Map Calendar ใหม่
  /// * [false] จะ เพิ่มวันที่ Inquiry ได้ใน Calendar เดิม
  // final bool resetCalendar;

  InquiryQueueSelectDateEvent({
    this.salesCartReserve,
    this.selectQueueDataItemDto,
    this.queueDataItemDtoList,
    this.inquiryDate,
    // this.timeNo,
    // this.worker,
    // this.resetCalendar,
  });

  @override
  String toString() {
    return 'InquiryQueueSelectDateEvent{salesCartReserve: $salesCartReserve, queueDataItemDtoList: $queueDataItemDtoList, inquiryDate: $inquiryDate}';
  }
}

class ReserveQueueEvent extends DeliveryInquiryReserveEvent {
  @override
  String toString() {
    return 'ReserveQueueEvent{}';
  }
}

class ReserveQueueInstallEvent extends DeliveryInquiryReserveEvent {
  @override
  String toString() {
    return 'ReserveQueueInstallEvent{}';
  }
}

class CalculateDeliveryFeeEvent extends DeliveryInquiryReserveEvent {
  final List<QueueDataItemDto> queueDataItems;

  CalculateDeliveryFeeEvent(this.queueDataItems);

  @override
  String toString() {
    return 'CalculateDeliveryFeeEvent{queueDataItems: $queueDataItems}';
  }
}
