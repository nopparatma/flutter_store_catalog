import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart' as CheckListQuestionRs;
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rs.dart';
import 'package:flutter_store_catalog/core/models/view/checklist_data.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/checklist_information_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/transaction_service.dart';
import 'package:meta/meta.dart';

part 'checklist_information_event.dart';

part 'checklist_information_state.dart';

class CheckListInformationBloc extends Bloc<CheckListInformationEvent, CheckListInformationState> {
  final CheckListInformationService serviceCheckListInformation = getIt<CheckListInformationService>();
  final TransactionService transactionService = getIt<TransactionService>();
  final SaleOrderService saleOrderService = getIt<SaleOrderService>();
  final ApplicationBloc applicationBloc;

  CheckListInformationBloc(this.applicationBloc);

  @override
  CheckListInformationState get initialState => InitialCheckListInformationState();

  @override
  Stream<CheckListInformationState> mapEventToState(CheckListInformationEvent event) async* {
    if (event is GetCheckListInformationQuestionEvent) {
      yield* mapGetCheckListInformationQuestionEvent(event);
    }
  }

  Stream<CheckListInformationState> mapGetCheckListInformationQuestionEvent(GetCheckListInformationQuestionEvent event) async* {
    try {
      yield LoadingCheckListInformationState();
      AppSession appSession = applicationBloc.state.appSession;

      GetCheckListInformationQuestionRq getCheckListInformationQuestionRq = new GetCheckListInformationQuestionRq();
      getCheckListInformationQuestionRq.mch = event.mch;
      getCheckListInformationQuestionRq.articleID = event.articleId;
      getCheckListInformationQuestionRq.sgTrnItemOid = event.sgTrnItemOid;
      getCheckListInformationQuestionRq.isCheckMapping = false;

      CheckListQuestionRs.GetCheckListInformationQuestionRs getCheckListInformationQuestionRs = await serviceCheckListInformation.getCheckListInformationQuestion(getCheckListInformationQuestionRq);

      if (getCheckListInformationQuestionRs.patternList != null) {
        for (CheckListQuestionRs.PatternList pattern in getCheckListInformationQuestionRs.patternList) {
          for (CheckListQuestionRs.ArtServiceList artService in pattern.artServiceList) {
            SearchArticle searchArticleBo = await getArticleForSalesCartItem(artService, appSession);
            artService.searchArticle = searchArticleBo;
          }
        }
      }

      CheckListInfo checkListInfo = ConvertCheckListInfo.convertQuestionToCheckListInfo(getCheckListInformationQuestionRs);

      yield SuccessGetCheckListInformationQuestionState(checkListInfo: checkListInfo);
    } catch (error, stackTrace) {
      yield ErrorCheckListInformationState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Future<SearchArticle> getArticleForSalesCartItem(CheckListQuestionRs.ArtServiceList artService, AppSession appSession) async {
    try {
      GetArticleForSalesCartItemRq getArticleForSalesCartItemRq = GetArticleForSalesCartItemRq();
      getArticleForSalesCartItemRq.searchData = artService.artcID;
      getArticleForSalesCartItemRq.storeId = appSession.userProfile.storeId;
      GetArticleForSalesCartItemRs getArticleForSalesCartItemRs = await saleOrderService.getArticleForSalesCartItem(appSession, getArticleForSalesCartItemRq);
      return getArticleForSalesCartItemRs.searchArticle;
    } catch (error) {
      return null;
    }
  }
}
