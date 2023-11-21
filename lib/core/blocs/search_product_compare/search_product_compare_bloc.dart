import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart' as CheckListQuestionRs;
import 'package:flutter_store_catalog/core/models/ecat/compare_article_attirbute_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/compare_article_attribute_rq.dart' as CompareArticleRq;
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:collection/collection.dart' as collection;
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rq.dart' as CheckListQuestionRq;
import 'package:flutter_store_catalog/core/services/dotnet/checklist_information_service.dart';

import '../../app_exception.dart';
import '../../get_it.dart';

part 'search_product_compare_state.dart';

part 'search_product_compare_event.dart';

class ProductCompareSearchBloc extends Bloc<ProductCompareSearchEvent, ProductCompareSearchState> {
  final CategoryService _categoryService = getIt<CategoryService>();
  final CheckListInformationService _checklistInformationService = getIt<CheckListInformationService>();

  final ApplicationBloc applicationBloc;

  ProductCompareSearchBloc(this.applicationBloc);

  @override
  ProductCompareSearchState get initialState => InitialProductCompareSearchState();

  @override
  Stream<ProductCompareSearchState> mapEventToState(ProductCompareSearchEvent event) async* {
    if (event is SearchProductCompareEvent) {
      yield* mapEventSearchProductCompareEvent(event);
    }
  }

  Stream<ProductCompareSearchState> mapEventSearchProductCompareEvent(SearchProductCompareEvent event) async* {
    try {
      yield LoadingProductCompareSearchState();

      List<ArticleList> articleList = [];
      List<String> mappingIdList = [];
      CompareArticleRq.CompareArticleAttributeRq compareArticleAttributeRq = new CompareArticleRq.CompareArticleAttributeRq();
      compareArticleAttributeRq.articleList = [];

      AppSession appSession = applicationBloc.state.appSession;

      for (int i = 0; i < event.articleList.length; i++) {
        ArticleList article = event.articleList[i];

        CompareArticleRq.ArticleList compareArticleList = new CompareArticleRq.ArticleList();
        compareArticleList.articleId = article.articleId;
        compareArticleAttributeRq.articleList.add(compareArticleList);

        //Get articleDetail
        GetArticleRq getArticleRq = GetArticleRq();
        getArticleRq.storeId = appSession.userProfile.storeId;
        getArticleRq.desc = article.articleId;

        var futureGetArticleRs = _categoryService.getArticleDetail(getArticleRq);

        // Get CheckList Information Question
        CheckListQuestionRq.GetCheckListInformationQuestionRq getCheckListInformationQuestionRq = new CheckListQuestionRq.GetCheckListInformationQuestionRq();
        getCheckListInformationQuestionRq.mch = article.mch9;
        getCheckListInformationQuestionRq.articleID = article.articleId;
        getCheckListInformationQuestionRq.isCheckMapping = true;

        var futureGetCheckListInformationQuestionRs = _checklistInformationService.getCheckListInformationQuestion(getCheckListInformationQuestionRq);

        await Future.wait([
          futureGetArticleRs,
          futureGetCheckListInformationQuestionRs,
        ], eagerError: true);

        GetArticleRs getArticleRs = await futureGetArticleRs;
        articleList.addAll(getArticleRs.articleList);

        CheckListQuestionRs.GetCheckListInformationQuestionRs getCheckListInformationQuestionRs = await futureGetCheckListInformationQuestionRs;
        mappingIdList.add(getCheckListInformationQuestionRs.insMapping);
      }

      CompareArticleAttributeRs compareArticleAttributeRs = await _categoryService.compareArticleAttribute(compareArticleAttributeRq);

      compareArticleAttributeRs.compareAttributeList?.sort((a, b) {
        return collection.compareAsciiLowerCaseNatural(a.attributeNameTH, b.attributeNameTH);
      });

      yield SearchProductCompareState(
        compareArticleAttributeRs: compareArticleAttributeRs,
        articleList: articleList,
        mappingIdList: mappingIdList,
      );
    } catch (error, stackTrace) {
      yield ErrorProductCompareSearchState(AppException(error, stackTrace: stackTrace));
    }
  }
}
