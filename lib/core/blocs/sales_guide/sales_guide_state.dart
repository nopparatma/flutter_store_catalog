part of 'sales_guide_bloc.dart';

@immutable
abstract class SalesGuideState {}

class InitialSalesGuideState extends SalesGuideState {
  @override
  String toString() {
    return 'InitialSalesGuideState{}';
  }
}

class LoadingSalesGuideState extends SalesGuideState {
  @override
  String toString() {
    return 'LoadingSalesGuideState{}';
  }
}

class ErrorSalesGuideState extends SalesGuideState {
  final dynamic error;

  ErrorSalesGuideState(this.error);

  @override
  String toString() {
    return 'ErrorSalesGuideState{error: $error}';
  }
}

class SalesGuideLoadSuccessState extends SalesGuideState {
  final List<KnowledgeList> knowledgeList;
  final CalculatorProductComponent calculateProductDisplay;

  SalesGuideLoadSuccessState({this.knowledgeList, this.calculateProductDisplay});

  @override
  String toString() {
    return 'SalesGuideLoadSuccessState{knowledgeList: $knowledgeList, calculateProductDisplay: $calculateProductDisplay}';
  }
}

class CalculateProductSuccessState extends SalesGuideState {
  final CalculatorRs calculatorRs;

  CalculateProductSuccessState({this.calculatorRs});

  @override
  String toString() {
    return 'CalculateProductSuccessState{calculatorRs: $calculatorRs}';
  }
}

class KnowledgeHtmlContentSuccessState extends SalesGuideState {
  final String htmlContent;

  KnowledgeHtmlContentSuccessState({this.htmlContent});

  @override
  String toString() {
    return 'KnowledgeHtmlContentSuccessState{htmlContent: $htmlContent}';
  }
}
