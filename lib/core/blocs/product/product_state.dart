part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class InitialProductState extends ProductState {
  @override
  String toString() {
    return 'InitialProductState{}';
  }
}

class LoadingProductState extends ProductState {
  @override
  String toString() {
    return 'LoadingProductState{}';
  }
}

class ErrorProductState extends ProductState {
  final dynamic error;

  ErrorProductState(this.error);

  @override
  String toString() {
    return 'ErrorProductState{error: $error}';
  }
}

class ProductLoadSuccessState extends ProductState {
  final ArticleList article;
  final String htmlContent;
  // final SearchPromotionRs searchPromotionRs;
  final List<ArticleList> lstSimilarProduct;
  final List<ArticleList> lstInterestProduct;
  final String insMappingId;
  final String calculatorId;
  final GetItemPromotionDetailRs itemPromotionDetail;
  final MstLabelLocationRs.GetMasterLabelLocationRs getMasterLabelLocationRs;

  ProductLoadSuccessState({
    this.article,
    this.htmlContent,
    this.lstSimilarProduct,
    this.lstInterestProduct,
    this.insMappingId,
    this.calculatorId,
    this.itemPromotionDetail,
    this.getMasterLabelLocationRs,
  });

  @override
  String toString() {
    return 'ProductLoadSuccessState{article: $article, htmlContent: $htmlContent, lstSimilarProduct: $lstSimilarProduct, lstInterestProduct: $lstInterestProduct, insMappingId: $insMappingId, calculatorId: $calculatorId, itemPromotionDetail: $itemPromotionDetail, getMasterLabelLocationRs: $getMasterLabelLocationRs}';
  }
}
