part of 'checklist_information_bloc.dart';

@immutable
abstract class CheckListInformationState {}

class InitialCheckListInformationState extends CheckListInformationState {
  @override
  String toString() {
    return 'InitialCheckListInformationState: {}';
  }
}

class LoadingCheckListInformationState extends CheckListInformationState {
  @override
  String toString() {
    return 'LoadingCheckListInformationState: {}';
  }
}

class ErrorCheckListInformationState extends CheckListInformationState {
  final dynamic error;
  ErrorCheckListInformationState({this.error});
  @override
  String toString() {
    return 'ErrorCheckListInformationState: {error: $error}';
  }
}

class SuccessGetCheckListInformationQuestionState extends CheckListInformationState {
  final CheckListInfo checkListInfo;

  SuccessGetCheckListInformationQuestionState({this.checkListInfo});

  @override
  String toString() {
    return 'SuccessGetCheckListInformationQuestionState: {CheckListInfo: $checkListInfo}';
  }
}