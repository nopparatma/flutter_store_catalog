import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';

import 'checklist_data.dart';

class BasketItem {
  String key;
  String keyOfMainItem;
  ArticleList article;
  num qty;
  bool isFreeItem = false;
  bool isFreeService = false;
  bool isInstallService = false;
  CheckListData checkListData;
  bool isServiceArea = false;
  bool isSpecialOrder = false;
  bool isSpecialDts = false;

  BasketItem(this.article, this.qty, {this.isFreeItem = false, this.checkListData});
  BasketItem.calcOldItem(SalesItem salesItem, BasketItem oldItem, String key, String keyOfMainItem, num qty) {
    article = oldItem.article;
    this.qty = qty;
    this.isFreeItem = salesItem.isFreeGoods;
    this.isFreeService  = salesItem.isHomeServiceFreeGoods;
    this.key = key;
    this.checkListData = oldItem.checkListData;
    this.keyOfMainItem = keyOfMainItem ?? oldItem.keyOfMainItem;
    this.isInstallService = oldItem.isInstallService;
  }
  BasketItem.calcNewItem(SalesItem salesItem, String keyOfMainItem) {
    article = ArticleList(
      articleId: salesItem.articleId,
      unitList: [
        UnitList(
          unit: salesItem.unit,
          normalPrice: salesItem.normalPrice,
          promotionPrice:  salesItem.promotionPrice,
        )
      ],
      articleNameTH: salesItem.articleDesc,
    );
    this.qty = salesItem.qty;
    this.isFreeItem = salesItem.isFreeGoods;
    this.isFreeService  = salesItem.isHomeServiceFreeGoods;
    this.keyOfMainItem = keyOfMainItem;
  }
  BasketItem.installService(SearchArticle searchArticle, num qty, String keyOfMainItem, bool isServiceArea) {
    article = ArticleList(
      articleId: searchArticle.articleId,
      unitList: [
        UnitList(
          unit: searchArticle.sellUnit,
          normalPrice: searchArticle.normalPrice,
          promotionPrice:  searchArticle.promotionPrice,
        )
      ],
      articleNameTH: searchArticle.articleDescription,
    );
    this.qty = qty;
    this.isInstallService = true;
    this.keyOfMainItem = keyOfMainItem;
    this.isServiceArea = isServiceArea;
  }

  bool isHaveSpecialPrice() {
    return article.unitList[0] != null ? article.unitList[0].promotionPrice != null && article.unitList[0].promotionPrice > 0 : false;
  }

  bool isShowImage() {
    return !isInstallService;
  }

  bool isShowArticleId() {
    return true;
  }

  bool isShowItemControl() {
    return true;
  }

  bool isEditableQty() {
    return !isFreeItem && !isFreeService && !isInstallService;
  }

  bool isRemovableItem() {
    return !isFreeItem && !isFreeService && !isInstallService;
  }

  bool isLocalImage() {
    return isFreeItem || isFreeService;
  }

  String getImageUrl() {
    if (isFreeService) return 'assets/images/free_service.png';
    if (isFreeItem) return 'assets/images/free_gift.png';
    return article.imageList.isNotNE ? article.imageList?.first?.imageSmall : '';
  }

  String getArticleId() {
    return StringUtil.trimLeftZero(article.articleId);
  }

  String getArticleDesc() {
    return article.articleNameTH;
  }

  String getUnit() {
    return article.unitList.first.unit;
  }

  String getMainUPC() {
    return article.unitList.first.mainUPC;
  }

  num getPromotionPrice() {
    num promotionPrice = article.unitList.first.promotionPrice;
    return promotionPrice != null && promotionPrice > 0 ? promotionPrice : null;
  }

  num getNormalPrice() {
    return article.unitList.first.normalPrice;
  }

  @override
  String toString() {
    return 'BasketItem{key: $key, keyOfMainItem: $keyOfMainItem, article: $article, qty: $qty, isFreeItem: $isFreeItem, isFreeService: $isFreeService, isInstallService: $isInstallService, checkListData: $checkListData, isServiceArea: $isServiceArea}';
  }
}
