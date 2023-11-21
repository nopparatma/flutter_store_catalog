part of 'sales_guide_bloc.dart';

@immutable
abstract class SalesGuideEvent {}

class SalesGuideLoadEvent extends SalesGuideEvent {
  final String mch;
  final List<String> knowledgeIdList;
  final String calculatorId;

  SalesGuideLoadEvent({this.mch, this.knowledgeIdList, this.calculatorId});

  @override
  String toString() {
    return 'SalesGuideLoadEvent{mch: $mch, knowledgeIdList: $knowledgeIdList, calculatorId: $calculatorId}';
  }
}

class CalculateProductEvent extends SalesGuideEvent {
  final CalculatorProductComponent componentDisplay;

  CalculateProductEvent({this.componentDisplay});

  @override
  String toString() {
    return 'CalculateProductEvent{componentDisplay: $componentDisplay}';
  }
}

class KnowledgeHtmlContentEvent extends SalesGuideEvent {
  final String knowledgeId;

  KnowledgeHtmlContentEvent({this.knowledgeId});

  @override
  String toString() {
    return 'KnowledgeHtmlContentEvent{knowledgeId: $knowledgeId}';
  }
}
