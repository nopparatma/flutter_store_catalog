part of 'basket_bloc.dart';

@immutable
class BasketState {
  final CalculatePromotionCARq calculatePromotionCARq;
  List<BasketItem> items;
  List<BasketItem> calculatedItems;
  num netTrnAmt;
  num deliveryFeeAmt;
  num totalDiscountAmt;
  num unpaidAmt;
  bool isPopWidget;

  BasketState({this.calculatePromotionCARq, this.items, this.calculatedItems, this.netTrnAmt = 0, this.deliveryFeeAmt = 0, this.totalDiscountAmt = 0, this.unpaidAmt = 0, this.isPopWidget = false});

  bool isFoundArticleCheckList(ArticleList article) {
    return items.any((element) => StringUtil.trimLeftZero(element.article.articleId) == StringUtil.trimLeftZero(article.articleId) && element.checkListData != null);
  }

  bool isFoundArticle() {
    return (items != null && items.length > 0);
  }

  @override
  String toString() {
    return 'BasketState{calculatePromotionCARq: $calculatePromotionCARq, items: $items, calculatedItems: $calculatedItems, netTrnAmt: $netTrnAmt, deliveryFeeAmt: $deliveryFeeAmt, totalDiscountAmt: $totalDiscountAmt, unpaidAmt: $unpaidAmt, isPopWidget: $isPopWidget}';
  }
}

class LoadingBasketState extends BasketState {
  LoadingBasketState.clone(BasketState state) {
    this.items = state.items;
    this.calculatedItems = state.calculatedItems;
    this.netTrnAmt = state.netTrnAmt;
    this.deliveryFeeAmt = state.deliveryFeeAmt;
    this.totalDiscountAmt = state.totalDiscountAmt;
    this.unpaidAmt = state.unpaidAmt;
  }
}

class ErrorBasketState extends BasketState {
  final dynamic error;

  ErrorBasketState({this.error});

  ErrorBasketState.clone(BasketState state, this.error) {
    this.items = state.items;
    this.calculatedItems = state.calculatedItems;
    this.netTrnAmt = state.netTrnAmt;
    this.deliveryFeeAmt = state.deliveryFeeAmt;
    this.totalDiscountAmt = state.totalDiscountAmt;
    this.unpaidAmt = state.unpaidAmt;
  }
}
