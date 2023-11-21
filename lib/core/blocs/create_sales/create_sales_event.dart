part of 'create_sales_bloc.dart';

@immutable
abstract class CreateSalesEvent {}

class SmsCreateSalesEvent extends CreateSalesEvent{
  final String qrPaymentType;
  final String billToCustNo;
  final String phoneNo;
  final String email;
  final CalculatePromotionCARs calculatePromotionCARs;

  SmsCreateSalesEvent(this.qrPaymentType, this.billToCustNo, this.phoneNo, this.email, this.calculatePromotionCARs);
}

class QRCreateSalesEvent extends CreateSalesEvent{
  final String qrPaymentType;
  final String billToCustNo;
  final String email;
  final CalculatePromotionCARs calculatePromotionCARs;

  QRCreateSalesEvent(this.qrPaymentType, this.billToCustNo, this.email, this.calculatePromotionCARs);
}

class CreateCollectSalesEvent extends CreateSalesEvent{

  final CalculatePromotionCARs calculatePromotionCARs;
  final bool isHirePurchase;

  CreateCollectSalesEvent(this.calculatePromotionCARs, this.isHirePurchase);
}

class ResetEvent extends CreateSalesEvent {}