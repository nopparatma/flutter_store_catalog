part of 'checklist_information_bloc.dart';

@immutable
abstract class CheckListInformationEvent {}

class GetCheckListInformationQuestionEvent extends CheckListInformationEvent {
  final String mch;
  final String articleId;
  final int sgTrnItemOid;

  GetCheckListInformationQuestionEvent({this.mch, this.articleId, this.sgTrnItemOid = 0});

  @override
  String toString() {
    return 'GetCheckListInformationQuestionEvent: {mch: $mch, articleId: $articleId, sgTrnItemOid: $sgTrnItemOid}';
  }
}