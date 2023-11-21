import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class SalesCartItemDto {
  bool isSelected;
  SalesCartItem salesCartItem;

  bool isEdit;
  bool isFreeInstallService;
  num priceManual;
  num normalPrice;
  num promotionPrice;
  String articleName;
  String unit;
  String sellUnit;
  String blockCodeId;
  String accountAssignmentGroup;
  num qtyReserve;
  List<String> unitList;
  List<ScalingPrice> scalingPrices;
  List<ArticleFeature> articleFeatures;
  List<ArticleSets> articleSets;
  List<ArticleSpecs> articleSpecs;

  List<SalesCartItemDto> premiumList;
  List<SalesCartItemDto> installServiceList;

  SalesCartItemDto({
    this.isSelected,
    this.salesCartItem,
    this.isEdit,
    this.isFreeInstallService,
    this.priceManual,
    this.normalPrice,
    this.promotionPrice,
    this.articleName,
    this.unit,
    this.sellUnit,
    this.unitList,
    this.scalingPrices,
    this.articleFeatures,
    this.articleSets,
    this.articleSpecs,
    this.premiumList,
    this.installServiceList,
    this.qtyReserve,
  }) {
    isEdit = false;
    isFreeInstallService = false;
  }
}

class CovertSaleCart {
  static SalesCartItemDto convertSearchArticleToSalesCartItemDto(SearchArticle searchArticle) {
    SalesCartItemDto salesCartItemDto = SalesCartItemDto();
    salesCartItemDto.salesCartItem = SalesCartItem();
    salesCartItemDto.salesCartItem.salesCartItemOid = 0;
    salesCartItemDto.salesCartItem.itemUpc = searchArticle.itemUpc;
    salesCartItemDto.salesCartItem.articleNo = searchArticle.articleId;
    salesCartItemDto.salesCartItem.itemDescription = searchArticle.articleDescription;
    salesCartItemDto.salesCartItem.isPriceReq = searchArticle.isPriceRequired ?? false;
    salesCartItemDto.salesCartItem.isQtyReq = searchArticle.isQuantityRequired ?? false;
    salesCartItemDto.salesCartItem.isLotReq = searchArticle.isLotReq ?? false;
    salesCartItemDto.salesCartItem.isMainPrd = false;
    salesCartItemDto.salesCartItem.isSalesSet = searchArticle.isSalesSet ?? false;
    salesCartItemDto.salesCartItem.mchId = searchArticle.mchId;
    salesCartItemDto.salesCartItem.isSpecialDts = false;
    salesCartItemDto.salesCartItem.isSpecialOrder = false;
    salesCartItemDto.salesCartItem.isSameDay = false;
    salesCartItemDto.salesCartItem.itemDescription = searchArticle.articleDescription;

    salesCartItemDto.isFreeInstallService = searchArticle.isFreeInstallService;
    salesCartItemDto.articleName = searchArticle.articleName;
    salesCartItemDto.sellUnit = searchArticle.sellUnit;
    salesCartItemDto.unitList = searchArticle.unitList;
    salesCartItemDto.promotionPrice = searchArticle.promotionPrice;
    salesCartItemDto.normalPrice = searchArticle.normalPrice;
    salesCartItemDto.articleSets = searchArticle.articleSets;
    salesCartItemDto.scalingPrices = searchArticle.scalingPriceBos;
    salesCartItemDto.articleSpecs = searchArticle.articleSpecs;
    salesCartItemDto.articleSets = searchArticle.articleSets;
    salesCartItemDto.articleFeatures = searchArticle.articleFeatures;
    salesCartItemDto.accountAssignmentGroup = searchArticle.accountAssignmentGroup;

    return salesCartItemDto;
  }
}
