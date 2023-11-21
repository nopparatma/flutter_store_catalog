import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'inquiry_transaction_event.dart';

part 'inquiry_transaction_state.dart';

class InquiryTransactionBloc extends Bloc<InquiryTransactionEvent, InquiryTransactionState> {

  @override
  InquiryTransactionState get initialState => InitialInquiryTransactionState();

  @override
  Stream<InquiryTransactionState> mapEventToState(InquiryTransactionEvent event) async* {
    if (event is ResetInquiryTransactionEvent) {
      yield InitialInquiryTransactionState();
    } else if (event is CancelInquiryTransactionEvent) {
      yield CancelInquiryTransactionState();
    }
  }
}
