part of 'inquiry_transaction_bloc.dart';

@immutable
abstract class InquiryTransactionEvent {}

class ResetInquiryTransactionEvent extends InquiryTransactionEvent {}

class CancelInquiryTransactionEvent extends InquiryTransactionEvent {}
