part of 'checklist_information_excess_bloc.dart';

@immutable
abstract class ChecklistInformationExcessEvent {}

class GetExcessProductEvent extends ChecklistInformationExcessEvent {
  final String mch;
  final String insProductGPID;

  GetExcessProductEvent({this.mch, this.insProductGPID});

  @override
  String toString() {
    return 'GetExcessProductEvent: {mch: $mch, articleId: $insProductGPID}';
  }
}