part of 'checklist_information_excess_bloc.dart';

@immutable
abstract class ChecklistInformationExcessState {}

class InitialChecklistInformationExcessState extends ChecklistInformationExcessState {}

class LoadingCheckListInformationExcessState extends ChecklistInformationExcessState {
  @override
  String toString() {
    return 'LoadingCheckListInformationExcessState: {}';
  }
}

class ErrorCheckListInformationExcessState extends ChecklistInformationExcessState {
  final dynamic error;
  ErrorCheckListInformationExcessState({this.error});
  @override
  String toString() {
    return 'ErrorCheckListInformationExcessState: {error: $error}';
  }
}

class SuccessGetExcessProductState extends ChecklistInformationExcessState {
  final GetExcessProductRs getExcessProductRs;

  SuccessGetExcessProductState({this.getExcessProductRs});

  @override
  String toString() {
    return 'SuccessGetExcessProductState: {GetExcessProductRs: $getExcessProductRs}';
  }
}