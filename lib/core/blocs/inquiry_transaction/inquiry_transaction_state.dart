part of 'inquiry_transaction_bloc.dart';

@immutable
abstract class InquiryTransactionState {}

class InitialInquiryTransactionState extends InquiryTransactionState {}

class CancelInquiryTransactionState extends InquiryTransactionState {}