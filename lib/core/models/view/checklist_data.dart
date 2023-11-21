import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart' as CheckListQuestionRs;

class CheckListData {
  CheckListInfo checkListInfo;
  String residenceSelected;
  String patternTypeSelected;
  String patternAreaSelected;
  bool isConfirmCondition;
  int sgTrnItemOid;

  CheckListData({this.checkListInfo, this.residenceSelected, this.patternTypeSelected, this.patternAreaSelected, this.isConfirmCondition});

  @override
  String toString() {
    return 'CheckListData{checkListInfo: $checkListInfo, residenceSelected: $residenceSelected, patternTypeSelected: $patternTypeSelected, patternAreaSelected: $patternAreaSelected, isConfirmCondition: $isConfirmCondition}';
  }
}

class CheckListInfo {
  String insMapping;
  String mch;
  String articleId;
  List<CheckListQuestionRs.ResidenceList> residenceList;
  List<CheckListQuestionRs.PatternList> patternTypeList;
  List<CheckListQuestionRs.PatternList> patternAreaList;
  List<CheckListQuestionRs.StandardList> standardList;
}

class ConvertCheckListInfo {
  static CheckListInfo convertQuestionToCheckListInfo(CheckListQuestionRs.GetCheckListInformationQuestionRs checkListQuestionRs) {
    CheckListInfo checkListInfo = CheckListInfo();
    checkListInfo.insMapping = checkListQuestionRs.insMapping;
    checkListInfo.mch = checkListQuestionRs.mch;
    checkListInfo.articleId = checkListQuestionRs.articleID;

    checkListInfo.residenceList = [];
    for (CheckListQuestionRs.ResidenceList residence in checkListQuestionRs.residenceList ?? []) {
      checkListInfo.residenceList.add(
        CheckListQuestionRs.ResidenceList(
          insResidenceID: residence.insResidenceID,
          insResidenceName: residence.insResidenceName,
          isSelected: residence.isSelected,
        ),
      );
    }

    checkListInfo.patternTypeList = [];
    checkListInfo.patternAreaList = [];
    for (CheckListQuestionRs.PatternList pattern in checkListQuestionRs.patternList ?? []) {
      List<CheckListQuestionRs.ArticleList> articleList = [];
      for (CheckListQuestionRs.ArticleList article in pattern.articleList) {
        articleList.add(
          CheckListQuestionRs.ArticleList(artcID: article.artcID),
        );
      }

      List<CheckListQuestionRs.ArtServiceList> artServiceList = [];
      for (CheckListQuestionRs.ArtServiceList article in pattern.artServiceList) {
        CheckListQuestionRs.ArtServiceList artService = CheckListQuestionRs.ArtServiceList();
        artService.artcID = article.artcID;
        artService.searchArticle = article.searchArticle;

        artServiceList.add(artService);
      }

      List<CheckListQuestionRs.ProductGPList> productGpList = [];
      for (CheckListQuestionRs.ProductGPList productGp in pattern.productGPList) {
        List<CheckListQuestionRs.ProductList> productList = [];
        for (CheckListQuestionRs.ProductList product in productGp.productList) {
          productList.add(
            CheckListQuestionRs.ProductList(
              insSTDProductID: product.insSTDProductID,
              insSTDProductName: product.insSTDProductName,
              insSTDProductUsed: product.insSTDProductUsed,
              insSTDProductUOM: product.insSTDProductUOM,
            ),
          );
        }

        productGpList.add(
          CheckListQuestionRs.ProductGPList(
            insProductGPID: productGp.insProductGPID,
            insProductGPName: productGp.insProductGPName,
            productList: productList,
          ),
        );
      }

      List<CheckListQuestionRs.PicList> picList = [];
      for (CheckListQuestionRs.PicList picture in pattern.picList) {
        picList.add(
          CheckListQuestionRs.PicList(picUrl: picture.picUrl),
        );
      }

      if ("T" == pattern.insPatternFormat) {
        checkListInfo.patternTypeList.add(
          CheckListQuestionRs.PatternList(
            insPatternID: pattern.insPatternID,
            insPatternName: pattern.insPatternName,
            insPatternFormat: pattern.insPatternFormat,
            insPatternType: pattern.insPatternType,
            insPatternMore: pattern.insPatternMore,
            isSelected: pattern.isSelected,
            articleList: articleList,
            artServiceList: artServiceList,
            productGPList: productGpList,
            picList: picList,
          ),
        );
      } else if ("A" == pattern.insPatternFormat) {
        checkListInfo.patternAreaList.add(
          CheckListQuestionRs.PatternList(
            insPatternID: pattern.insPatternID,
            insPatternName: pattern.insPatternName,
            insPatternFormat: pattern.insPatternFormat,
            insPatternType: pattern.insPatternType,
            insPatternMore: pattern.insPatternMore,
            isSelected: pattern.isSelected,
            articleList: articleList,
            artServiceList: artServiceList,
            productGPList: productGpList,
            picList: picList,
          ),
        );
      }
    }

    checkListInfo.standardList = [];
    for (CheckListQuestionRs.StandardList standard in checkListQuestionRs.standardList ?? []) {
      checkListInfo.standardList.add(
        CheckListQuestionRs.StandardList(
          insStandardID: standard.insStandardID,
          insStandardName: standard.insStandardName,
          insStandardDetail: standard.insStandardDetail,
        ),
      );
    }

    return checkListInfo;
  }
}
