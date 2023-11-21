import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_store_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_store_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/search_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/cross_sell_item_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/cross_sell_item_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rq.dart' as CheckListQuestionRq;
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart' as CheckListQuestionRs;
import 'package:flutter_store_catalog/core/models/dotnet/get_master_label_location_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_master_label_location_rs.dart' as MstLabelLocationRs;
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_guide_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/similar_item_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/similar_item_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_item_promotion_detail_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_item_promotion_detail_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/promotion_bkoffc_service.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/stock_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/schematic_service.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/promotion_service.dart' as SalesPromotionService;
import 'package:flutter_store_catalog/core/services/dotnet/article_service.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/core/services/dotnet/checklist_information_service.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart' as collection;
import '../../get_it.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final PromotionBkoffcService _promotionService = getIt<PromotionBkoffcService>();
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();
  final ArticleService _articleService = getIt<ArticleService>();
  final CheckListInformationService _checklistInformationService = getIt<CheckListInformationService>();
  final SalesPromotionService.PromotionService _salesPromotionService = getIt<SalesPromotionService.PromotionService>();
  final SchematicService _schematicService = getIt<SchematicService>();

  final ApplicationBloc applicationBloc;

  ProductBloc(this.applicationBloc);

  @override
  ProductState get initialState => InitialProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductLoadEvent) {
      yield* mapEventLoadProductToState(event);
    }
  }

  Stream<ProductState> mapEventLoadProductToState(ProductLoadEvent event) async* {
    try {
      yield LoadingProductState();

      if (event.article == null) {
        yield ProductLoadSuccessState();
        return;
      }

      AppSession appSession = applicationBloc.state.appSession;

      var futureGetArticleRs = getArticleDetail(appSession, event.article);
      // var futureSearchPromotionRs = searchPromotion(appSession, event.article);
      var futureGetSimilarProduct = getSimilarProduct(appSession, event.article);
      var futureGetCrossSellProduct = getCrossSellProduct(appSession, event.article);
      var futureGetCheckListInformationQuestion = getCheckListInformationQuestion(event.article);
      var futureGetProductGuide = getProductGuide(event.article);
      var futureGetItemPromotionDetail = getItemPromotionDetail(appSession, event.article);
      // var futureGetMasterLabelLocation = getMasterLabelLocation(appSession, event.article);

      // parallel
      await Future.wait([
        futureGetArticleRs,
        // futureSearchPromotionRs,
        futureGetSimilarProduct,
        futureGetCrossSellProduct,
        futureGetCheckListInformationQuestion,
        futureGetProductGuide,
        futureGetItemPromotionDetail,
        // futureGetMasterLabelLocation,
      ], eagerError: true);

      GetArticleRs getArticleRs = await futureGetArticleRs;

      if (getArticleRs.messageStatusRs != null && "S" == getArticleRs.messageStatusRs.status && StringUtil.isNotEmpty(getArticleRs.messageStatusRs.message)) {
        yield ErrorProductState(getArticleRs.messageStatusRs.message);
        return;
      }

      // SearchPromotionRs searchPromotionRs = await futureSearchPromotionRs;
      List<ArticleList> similarList = await futureGetSimilarProduct;
      List<ArticleList> crossSellList = await futureGetCrossSellProduct;
      String insMappingId = await futureGetCheckListInformationQuestion;
      GetProductGuideRs getProductGuideRs = await futureGetProductGuide;
      GetItemPromotionDetailRs getItemPromotionDetailRs = await futureGetItemPromotionDetail;
      MstLabelLocationRs.GetMasterLabelLocationRs getMasterLabelLocationRs; //await futureGetMasterLabelLocation; // 'แถวที่ 61 A 1-4';

      String htmlToParse = '';
      if (StringUtil.isNotEmpty(getArticleRs.articleList[0].contentTH)) {
        htmlToParse = await _categoryService.getContent(ImageUtil.getFullURL(getArticleRs.articleList[0].contentTH));
      }

      // sort
      if (getArticleRs.articleList.isNotEmpty) {
        ArticleList article = getArticleRs.articleList[0];
        article.featureList?.sort((a, b) {
          return collection.compareAsciiLowerCaseNatural(a.featureNameTH, b.featureNameTH);
        });
      }

      yield ProductLoadSuccessState(
        article: getArticleRs.articleList[0],
        htmlContent: htmlToParse,
        // searchPromotionRs: searchPromotionRs,
        lstSimilarProduct: similarList,
        lstInterestProduct: crossSellList,
        insMappingId: insMappingId,
        calculatorId: (getProductGuideRs?.grouping != null && getProductGuideRs.grouping.length > 0) ? getProductGuideRs?.grouping?.first?.calculator : '',
        itemPromotionDetail: getItemPromotionDetailRs,
        getMasterLabelLocationRs: getMasterLabelLocationRs,
      );
    } catch (error, stackTrace) {
      yield ErrorProductState(AppException(error, stackTrace: stackTrace));
    }
  }

  Future<GetArticleRs> getArticleDetail(AppSession appSession, ArticleList article) async {
    GetArticleRq getArticleRq = GetArticleRq();
    getArticleRq.storeId = appSession.userProfile.storeId;
    getArticleRq.desc = article.articleId;

    return await _categoryService.getArticleDetail(getArticleRq);
  }

  // Future<SearchPromotionRs> searchPromotion(AppSession appSession, ArticleList article) async {
  //   SearchPromotionRq searchPromotionRq = SearchPromotionRq();
  //   searchPromotionRq.storeId = appSession.userProfile.storeId;
  //   searchPromotionRq.startRow = 0;
  //   searchPromotionRq.pagesize = 0;
  //   searchPromotionRq.articleNo = article.articleId;
  //   searchPromotionRq.unit = article.unitList[0].unit;
  //
  //   return await _promotionService.searchPromotion(appSession, searchPromotionRq);
  // }

  Future<List<ArticleList>> getSimilarProduct(AppSession appSession, ArticleList article) async {
    SimilarItemRq similarItemRq = SimilarItemRq(articleId: article.articleId);
    SimilarItemRs similarItemRs = await _articleService.similarItem(similarItemRq);

    if (similarItemRs.similarItemList == null || similarItemRs.similarItemList.length == 0) return null;

    List<Article> articleList = [];
    similarItemRs.similarItemList.forEach((item) {
      articleList.add(Article(item));
    });

    GetArticleRq similarRq = GetArticleRq(storeId: appSession.userProfile.storeId, startRow: 0, pageSize: articleList.length, articleList: articleList);
    GetArticleRs similarRs = await _categoryService.getArticlePaging(similarRq);

    return similarRs.articleList;
  }

  Future<List<ArticleList>> getCrossSellProduct(AppSession appSession, ArticleList article) async {
    CrossSellItemRq crossSellItemRq = CrossSellItemRq(articleId: article.articleId);
    CrossSellItemRs crossSellItemRs = await _articleService.crossSellItem(crossSellItemRq);

    if (crossSellItemRs.crossSellItemList == null || crossSellItemRs.crossSellItemList.length == 0) return null;

    List<Article> articleList = [];
    crossSellItemRs.crossSellItemList.forEach((item) {
      articleList.add(Article(item));
    });

    GetArticleRq crossSellRq = GetArticleRq(storeId: appSession.userProfile.storeId, startRow: 0, pageSize: articleList.length, articleList: articleList);
    GetArticleRs crossSellRs = await _categoryService.getArticlePaging(crossSellRq);

    return crossSellRs.articleList;
  }

  Future<GetProductGuideRs> getProductGuide(ArticleList article) async {
    GetProductGuideRq getProductGuideRq = GetProductGuideRq();
    getProductGuideRq.mCHList = StringUtil.isNullOrEmpty(article.mch9) ? [] : []
      ..add(article.mch9);

    return await _articleService.getProductGuide(getProductGuideRq);
  }

  Future<String> getCheckListInformationQuestion(ArticleList article) async {
    CheckListQuestionRq.GetCheckListInformationQuestionRq getCheckListInformationQuestionRq = new CheckListQuestionRq.GetCheckListInformationQuestionRq();
    getCheckListInformationQuestionRq.mch = article.mch9;
    getCheckListInformationQuestionRq.articleID = article.articleId;
    getCheckListInformationQuestionRq.isCheckMapping = true;

    CheckListQuestionRs.GetCheckListInformationQuestionRs getCheckListInformationQuestionRs = await _checklistInformationService.getCheckListInformationQuestion(getCheckListInformationQuestionRq);
    return getCheckListInformationQuestionRs.insMapping;
  }

  Future<GetItemPromotionDetailRs> getItemPromotionDetail(AppSession appSession, ArticleList article) async {
    GetItemPromotionDetailRq getItemPromotionDetailRq = GetItemPromotionDetailRq();
    getItemPromotionDetailRq.articleId = article.articleId;
    getItemPromotionDetailRq.unit = article.unitList[0].unit;
    getItemPromotionDetailRq.storeId = appSession.userProfile.storeId;

    return await _salesPromotionService.getItemPromotionDetail(appSession, getItemPromotionDetailRq);
  }

  Future<MstLabelLocationRs.GetMasterLabelLocationRs> getMasterLabelLocation(AppSession appSession, ArticleList article) async {
    GetMasterLabelLocationRq getMasterLabelLocationRq = GetMasterLabelLocationRq()
      ..storeId = appSession.userProfile.storeId
      ..mainUPC = article.mch9
      ..articleId = article.articleId
      ..uom = article.unitList[0].unit;

    return await _schematicService.getMasterLabelLocation(getMasterLabelLocationRq);
  }
}
