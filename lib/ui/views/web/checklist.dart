import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/checklist_information/checklist_information_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/checklist_information_excess/checklist_information_excess_bloc.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rs.dart' as GetExcessProductRs;
import 'package:flutter_store_catalog/core/models/view/checklist_data.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_checkbox.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_html.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart' as GetArticleRs;
import 'package:easy_localization/easy_localization.dart';
import 'package:photo_view/photo_view.dart';

class CheckListPage extends StatefulWidget {
  final GetArticleRs.ArticleList article;

  const CheckListPage({
    Key key,
    this.article,
  }) : super(key: key);

  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => CheckListInformationBloc(BlocProvider.of<ApplicationBloc>(context))
            ..add(
              GetCheckListInformationQuestionEvent(mch: widget.article.mch9, articleId: widget.article.articleId),
            ),
        ),
      ],
      child: CommonLayout(
        isShowBack: true,
        bodyBackgroundColor: Colors.white,
        body: BlocConsumer<CheckListInformationBloc, CheckListInformationState>(
          listenWhen: (prevState, currentState) {
            if (prevState is LoadingCheckListInformationState) {
              DialogUtil.hideLoadingDialog(context);
            }
            return true;
          },
          listener: (context, state) async {
            if (state is ErrorCheckListInformationState) {
              DialogUtil.showErrorDialog(context, state.error);
            } else if (state is LoadingCheckListInformationState) {
              DialogUtil.showLoadingDialog(context);
            }
          },
          buildWhen: (previous, current) {
            return (current is InitialCheckListInformationState || current is SuccessGetCheckListInformationQuestionState);
          },
          builder: (context, state) {
            if (state is SuccessGetCheckListInformationQuestionState) {
              return CheckListPanel(
                checkListData: CheckListData(checkListInfo: state.checkListInfo),
                articleDetail: widget.article,
                modeEdit: true,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class ViewAnswerPanel extends StatefulWidget {
  final GetArticleRs.ArticleList articleDetail;
  int sgTrnItemOid;

  ViewAnswerPanel({
    Key key,
    this.articleDetail,
    this.sgTrnItemOid,
  }) : super(key: key);

  @override
  _ViewAnswerPanelState createState() => _ViewAnswerPanelState();
}

class _ViewAnswerPanelState extends State<ViewAnswerPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => CheckListInformationBloc(BlocProvider.of<ApplicationBloc>(context))
            ..add(
              GetCheckListInformationQuestionEvent(sgTrnItemOid: widget.sgTrnItemOid),
            ),
        ),
      ],
      child: BlocConsumer<CheckListInformationBloc, CheckListInformationState>(
        listenWhen: (prevState, currentState) {
          if (prevState is LoadingCheckListInformationState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) async {
          if (state is ErrorCheckListInformationState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is LoadingCheckListInformationState) {
            DialogUtil.showLoadingDialog(context);
          }
        },
        buildWhen: (previous, current) {
          return (current is InitialCheckListInformationState || current is SuccessGetCheckListInformationQuestionState);
        },
        builder: (context, state) {
          if (state is SuccessGetCheckListInformationQuestionState) {
            return CheckListPanel(
              checkListData: CheckListData(checkListInfo: state.checkListInfo),
              articleDetail: widget.articleDetail,
              modeEdit: false,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class CheckListPanel extends StatefulWidget {
  CheckListData checkListData;
  GetArticleRs.ArticleList articleDetail;
  bool modeEdit;

  CheckListPanel({
    Key key,
    this.checkListData,
    this.articleDetail,
    this.modeEdit = true,
  }) : super(key: key);

  @override
  _CheckListPanelState createState() => _CheckListPanelState();
}

class _CheckListPanelState extends State<CheckListPanel> {
  bool isConfirmCondition = false;
  int choice;
  int indexPatternType;
  int indexPatternArea;
  bool lockTermCondition = false;
  bool isLandScape = false;
  PatternList patternTypeSelected;
  PatternList patternAreaSelected;
  ScrollController scrollController;
  CheckListData dataSelected = CheckListData();

  @override
  void initState() {
    super.initState();

    if (widget.modeEdit) {
      dataSelected.residenceSelected = widget.checkListData.residenceSelected ?? '';
      dataSelected.patternTypeSelected = widget.checkListData.patternTypeSelected ?? '';
      dataSelected.patternAreaSelected = widget.checkListData.patternAreaSelected ?? '';
      isConfirmCondition = widget.checkListData.isConfirmCondition ?? false;
      lockTermCondition = isConfirmCondition ?? false;
    } else {
      ResidenceList residence = widget.checkListData.checkListInfo.residenceList.firstWhere((element) => element.isSelected, orElse: () => null);
      if (residence != null) {
        dataSelected.residenceSelected = residence.insResidenceID;
      }

      PatternList patternType = widget.checkListData.checkListInfo.patternTypeList.firstWhere((element) => element.isSelected, orElse: () => null);
      if (patternType != null) {
        dataSelected.patternTypeSelected = patternType.insPatternID;
      }

      PatternList patternArea = widget.checkListData.checkListInfo.patternAreaList.firstWhere((element) => element.isSelected, orElse: () => null);
      if (patternArea != null) {
        dataSelected.patternAreaSelected = patternArea.insPatternID;
      }

      isConfirmCondition = true;
      lockTermCondition = true;
    }

    scrollController = ScrollController();
  }

  void onSelectPatternType() {
    if (StringUtil.isNotEmpty(dataSelected.patternTypeSelected)) {
      patternTypeSelected = PatternList();
      patternTypeSelected = widget.checkListData.checkListInfo.patternTypeList?.firstWhere((element) => element.insPatternID == dataSelected.patternTypeSelected);
    }
  }

  void onSelectPatternArea() {
    if (StringUtil.isNotEmpty(dataSelected.patternAreaSelected)) {
      patternAreaSelected = PatternList();
      patternAreaSelected = widget.checkListData.checkListInfo.patternAreaList?.firstWhere((element) => element.insPatternID == dataSelected.patternAreaSelected);
    }
  }

  onTapInfoButton(List<PicList> picList) {
    DialogUtil.showCustomDialog(context, child: ViewInfoImagePanel(picList));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChecklistInformationExcessBloc(),
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            isLandScape = true;
          } else {
            isLandScape = false;
          }

          return buildDetail(context, widget.checkListData.checkListInfo, widget.articleDetail);
        },
      ),
    );
  }

  Widget buildDetail(BuildContext context, CheckListInfo checkListInfo, GetArticleRs.ArticleList articleDetail) {
    if (isLockEditCheckBox()) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.clipboardCheckOutline,
                color: colorDark,
                size: 30,
              ),
              SizedBox(width: 10),
              buildTextRow(
                'text.header_checklist'.tr(),
                Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          buildTextRow('text.specify_information_and_fill_correct'.tr(), Theme.of(context).textTheme.normal),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildArticleHeader(context, articleDetail),
                        buildMappingCheckList(context, checkListInfo),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildFooterButton(),
        ],
      );
    }

    return Scaffold(
      body: ListView(
        controller: scrollController,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildArticleHeader(context, articleDetail),
                  buildMappingCheckList(context, checkListInfo),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
    );
  }

  Widget buildArticleHeader(BuildContext context, GetArticleRs.ArticleList articleDetail) {
    return Padding(
      padding: isLockEditCheckBox() ? const EdgeInsets.only(left: 40) : const EdgeInsets.only(left: 0),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: buildTextRow(
                  StringUtil.isNotEmpty(articleDetail.articleFullNameTH)
                      ? LanguageUtil.isTh(context)
                          ? '${articleDetail.articleFullNameTH} '
                          : '${articleDetail.articleFullNameEN} '
                      : LanguageUtil.isTh(context)
                          ? '${articleDetail.articleNameTH} '
                          : '${articleDetail.articleNameEN} ',
                  Theme.of(context).textTheme.normal.copyWith(color: colorDark)),
            ),
            WidgetSpan(
              child: buildTextRow(
                'text.sku.colon'.tr(args: ['${StringUtil.trimLeftZero(articleDetail.articleId)} ']),
                Theme.of(context).textTheme.normal.copyWith(color: colorDark),
              ),
            ),
            WidgetSpan(
              child: buildPrice(context, articleDetail),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMappingCheckList(BuildContext context, CheckListInfo checkListInfo) {
    choice = 0;
    bool isNotLockCheckBox = !isLockEditCheckBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNotLockCheckBox)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  MdiIcons.clipboardCheckOutline,
                  color: colorDark,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                buildTextRow(
                  'text.header_checklist'.tr(),
                  Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNotLockCheckBox) buildTextRow('text.specify_information_and_fill_correct'.tr(), Theme.of(context).textTheme.normal),
                buildResidence(context, checkListInfo.residenceList),
                buildPatternType(context, checkListInfo.patternTypeList),
                buildPatternArea(context, checkListInfo.patternAreaList),
                buildProduct(context, checkListInfo.patternTypeList, checkListInfo.patternAreaList),
                buildStandard(context, checkListInfo.standardList),
                Padding(padding: const EdgeInsets.symmetric(vertical: 15.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCheckbox(
                      isCheckIcon: true,
                      value: isLockEditCheckBox() ? true : isConfirmCondition,
                      onChanged: isLockEditCheckBox()
                          ? null
                          : (value) {
                              setState(() {
                                isConfirmCondition = value;
                              });
                            },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextRow(
                              'text.accept_terms_of_service'.tr(),
                              Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isNotLockCheckBox) buildButton(context, checkListInfo),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isLockEditCheckBox() {
    return !widget.modeEdit || lockTermCondition;
  }

  Widget buildButton(BuildContext context, CheckListInfo checkListInfo) {
    if (!widget.modeEdit) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: buildButtonClose(context),
        ),
      );
    }

    if (MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height) {
      return buildButtonLanscape(context, checkListInfo);
    } else {
      return buildButtonPortrait(context, checkListInfo);
    }
  }

  Widget buildFooterButton() {
    if (!widget.modeEdit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            width: 480,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: colorBlue7,
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'common.dialog_button_close'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: colorAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(18),
              ),
              child: Text('text.back'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: colorBlue7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(18),
              ),
              child: Text('common.dialog_button_ok'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
              onPressed: isEnableOKButton() ? null : onConfirm,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonLanscape(BuildContext context, CheckListInfo checkListInfo) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
          children: [
            buildButtonBack(context, checkListInfo),
            SizedBox(
              width: 30,
            ),
            buildButtonOK(context, checkListInfo),
          ],
        ),
      ),
    );
  }

  Widget buildButtonPortrait(BuildContext context, CheckListInfo checkListInfo) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            buildButtonBack(context, checkListInfo),
            SizedBox(
              height: 30,
            ),
            buildButtonOK(context, checkListInfo),
          ],
        ),
      ),
    );
  }

  Widget buildResidence(BuildContext context, List<ResidenceList> residenceList) {
    if (residenceList == null || residenceList.length == 0) {
      return SizedBox.shrink();
    }

    choice++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: colorDark,
                radius: 16,
                child: Text(
                  '${choice.toString()}',
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   width: 30,
            //   alignment: Alignment.centerLeft,
            //   child: Ink(
            //     padding: EdgeInsets.all(8),
            //     decoration: new BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: colorDark,
            //     ),
            //     child: buildTextRow(
            //       '${choice.toString()}',
            //       Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildTextRow(
                'text.select_residence'.tr(),
                Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: residenceList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              ResidenceList residence = residenceList[index];
              return InkWell(
                child: buildResidenceRow(context, residence, index + 1, residence.insResidenceID == dataSelected.residenceSelected),
                onTap: !widget.modeEdit
                    ? null
                    : () {
                        setState(() {
                          if (widget.modeEdit) {
                            dataSelected.residenceSelected = residence.insResidenceID;
                          }
                        });
                      },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildResidenceRow(BuildContext context, ResidenceList residence, num index, bool isSelected) {
    return Card(
      color: isSelected ? colorBlue5 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: isSelected ? colorBlue7 : Colors.white,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        child: Row(
          crossAxisAlignment: isLandScape ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    side: BorderSide(
                      color: colorDark,
                    ),
                  ),
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    child: buildTextRow(
                      '${index.toString()}',
                      Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextRow(
                      '${residence.insResidenceName}',
                      Theme.of(context).textTheme.normal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPatternType(BuildContext context, List<PatternList> patternList) {
    if (patternList == null || patternList.length == 0) {
      return SizedBox.shrink();
    }

    choice++;
    indexPatternType = 0;
    onSelectPatternType();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: colorDark,
                radius: 16,
                child: Text(
                  '${choice.toString()}',
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   width: 30,
            //   alignment: Alignment.centerLeft,
            //   child: Ink(
            //     padding: EdgeInsets.all(8),
            //     decoration: new BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: colorDark,
            //     ),
            //     child: buildTextRow(
            //       '${choice.toString()}',
            //       Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildTextRow(
                'text.select_pattern_type'.tr(),
                Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: patternList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              PatternList pattern = patternList[index];
              return InkWell(
                child: isLandScape ? buildPatternTypeLandScapeRow(context, pattern, indexPatternType, pattern.insPatternID == dataSelected.patternTypeSelected) : buildPatternTypePortraitRow(context, pattern, indexPatternType, pattern.insPatternID == dataSelected.patternTypeSelected),
                onTap: !widget.modeEdit
                    ? null
                    : () {
                        setState(() {
                          if (widget.modeEdit) {
                            dataSelected.patternTypeSelected = pattern.insPatternID;
                          }
                        });
                      },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildPatternTypeLandScapeRow(BuildContext context, PatternList pattern, num index, bool isSelected) {
    indexPatternType++;

    return Card(
      color: isSelected ? colorBlue5 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: isSelected ? colorBlue7 : Colors.white,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        child: buildPatternDetailLandScapeRow(context, pattern, pattern.insPatternType, indexPatternType.toString()),
      ),
    );
  }

  Widget buildPatternTypePortraitRow(BuildContext context, PatternList pattern, num index, bool isSelected) {
    indexPatternType++;

    return Card(
      color: isSelected ? colorBlue5 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: isSelected ? colorBlue7 : Colors.white,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    side: BorderSide(
                      color: colorDark,
                    ),
                  ),
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    child: buildTextRow(
                      '${indexPatternType.toString()}',
                      Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: buildPatternDetailPortraitRow(context, pattern, pattern.insPatternType),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPatternArea(BuildContext context, List<PatternList> patternList) {
    if (patternList == null || patternList.length == 0) {
      return SizedBox.shrink();
    }

    choice++;
    indexPatternArea = 0;
    onSelectPatternArea();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: colorDark,
                radius: 16,
                child: Text(
                  '${choice.toString()}',
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   width: 30,
            //   alignment: Alignment.centerLeft,
            //   child: Ink(
            //     padding: EdgeInsets.all(8),
            //     decoration: new BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: colorDark,
            //     ),
            //     child: buildTextRow(
            //       '${choice.toString()}',
            //       Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildTextRow(
                'text.specify_pattern_area'.tr(),
                Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: patternList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              PatternList pattern = patternList[index];
              return InkWell(
                child: isLandScape ? buildPatternAreaLandScapeRow(context, pattern, indexPatternArea, pattern.insPatternID == dataSelected.patternAreaSelected) : buildPatternAreaPortraitRow(context, pattern, indexPatternArea, pattern.insPatternID == dataSelected.patternAreaSelected),
                onTap: !widget.modeEdit
                    ? null
                    : () {
                        setState(() {
                          if (widget.modeEdit) {
                            // toggle
                            if (StringUtil.isNotEmpty(dataSelected.patternAreaSelected) && dataSelected.patternAreaSelected == pattern.insPatternID) {
                              dataSelected.patternAreaSelected = null;
                            } else {
                              dataSelected.patternAreaSelected = pattern.insPatternID;
                            }
                          }
                        });
                      },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildPatternAreaLandScapeRow(BuildContext context, PatternList pattern, num index, bool isSelected) {
    indexPatternArea++;

    return Card(
      color: isSelected ? colorBlue5 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: isSelected ? colorBlue7 : Colors.white,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        child: buildPatternDetailLandScapeRow(context, pattern, pattern.insPatternType, indexPatternArea.toString()),
      ),
    );
  }

  Widget buildPatternAreaPortraitRow(BuildContext context, PatternList pattern, num index, bool isSelected) {
    indexPatternArea++;

    return Card(
      color: isSelected ? colorBlue5 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: isSelected ? colorBlue7 : Colors.white,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    side: BorderSide(
                      color: colorDark,
                    ),
                  ),
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    child: buildTextRow(
                      '${indexPatternArea.toString()}',
                      Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: buildPatternDetailPortraitRow(context, pattern, pattern.insPatternType),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPatternDetailPortraitRow(BuildContext context, PatternList pattern, String type) {
    if ("F" == type) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextRow('${pattern.insPatternName}', Theme.of(context).textTheme.normal),
          Row(
            children: [
              buildTextRow(
                'text.checklist_service_free'.tr(),
                Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextRow('${pattern.insPatternName}', Theme.of(context).textTheme.normal),
          buildPatternCostRow(context, pattern),
        ],
      );
    }
  }

  Widget buildPatternCostRow(BuildContext context, PatternList pattern) {
    if (pattern.checkHaveSearchArticle()) {
      return Row(
        children: [
          buildTextRow(
            '${StringUtil.getDefaultCurrencyFormat(pattern.getCost())}',
            Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          buildTextRow(' ', Theme.of(context).textTheme.normal),
          buildTextRow(
            'text.baht'.tr(),
            Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildPatternDetailLandScapeRow(BuildContext context, PatternList pattern, String type, String index) {
    if ("F" == type) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  side: BorderSide(
                    color: colorDark,
                  ),
                ),
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  child: buildTextRow(
                    index,
                    Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextRow('${pattern.insPatternName}', Theme.of(context).textTheme.normal),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextRow(' ', Theme.of(context).textTheme.normal),
                ],
              ),
            ),
          ),
          buildTextRow(' ', Theme.of(context).textTheme.normal),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextRow(
                  'text.checklist_service_free'.tr(),
                  Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
          buildInfoButton(context, pattern?.picList),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  side: BorderSide(
                    color: colorDark,
                  ),
                ),
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  child: buildTextRow(
                    index,
                    Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextRow('${pattern.insPatternName}', Theme.of(context).textTheme.normal),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: buildPatternCostLandScapeRow(context, pattern),
          ),
          buildInfoButton(context, pattern?.picList),
        ],
      );
    }
  }

  Widget buildPatternCostLandScapeRow(BuildContext context, PatternList pattern) {
    if (pattern.checkHaveSearchArticle()) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextRow(
                    '${StringUtil.getDefaultCurrencyFormat(pattern.getCost())}',
                    Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          buildTextRow(' ', Theme.of(context).textTheme.normal),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextRow(
                  'text.baht'.tr(),
                  Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildProduct(BuildContext context, List<PatternList> patternTypeList, List<PatternList> patternAreaList) {
    choice++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: colorDark,
                radius: 16,
                child: Text(
                  '${choice.toString()}',
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   width: 30,
            //   alignment: Alignment.centerLeft,
            //   child: Ink(
            //     padding: EdgeInsets.all(8),
            //     decoration: new BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: colorDark,
            //     ),
            //     child: buildTextRow(
            //       '${choice.toString()}',
            //       Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildTextRow(
                'text.select_standard_equipment'.tr(),
                Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        buildArticlePatternType(context, patternTypeList),
        buildArticlePatternArea(context, patternAreaList),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: buildTextRow(
                  'text.warning_standard_equipment'.tr(),
                  Theme.of(context).textTheme.normal,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: buildLinkExcessProduct(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildArticlePatternType(BuildContext context, List<PatternList> patternList) {
    if (StringUtil.isNullOrEmpty(dataSelected.patternTypeSelected) || patternTypeSelected == null || patternTypeSelected.productGPList == null || patternTypeSelected.productGPList.length == 0) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 2),
          child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
          child: buildTextRow(
            'text.pattern_type'.tr(),
            Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 2),
          child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: isLandScape ? const EdgeInsets.symmetric(horizontal: 80.0, vertical: 5) : const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: patternTypeSelected?.productGPList?.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return buildProductGroupRow(context, patternTypeSelected?.productGPList[index], index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget buildArticlePatternArea(BuildContext context, List<PatternList> patternList) {
    if (StringUtil.isNullOrEmpty(dataSelected.patternAreaSelected) || patternAreaSelected == null || patternAreaSelected.productGPList == null || patternAreaSelected.productGPList.length == 0) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 2),
          child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
          child: buildTextRow(
            'text.pattern_area'.tr(),
            Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 2),
          child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: isLandScape ? const EdgeInsets.symmetric(horizontal: 80.0, vertical: 5) : const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: patternAreaSelected?.productGPList?.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return buildProductGroupRow(context, patternAreaSelected?.productGPList[index], index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget buildProductGroupRow(BuildContext context, ProductGPList productGP, num index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index != 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: buildTextRow(
                  '${index.toString()}. ${productGP.insProductGPName}',
                  Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: isLandScape ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5) : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: productGP?.productList?.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                ProductList product = productGP?.productList[index];
                return isLandScape ? buildProductLandScapeRow(context, product, index + 1, productGP?.productList?.length) : buildProductPortraitRow(context, product, index + 1, productGP?.productList?.length);
              }),
        ),
      ],
    );
  }

  Widget buildProductLandScapeRow(BuildContext context, ProductList product, num index, num indexmax) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: buildTextRow(
                  '${index.toString()}. ${product.insSTDProductName}',
                  Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextRow(
                        product.insSTDProductUsed.toString(),
                        Theme.of(context).textTheme.normal,
                      ),
                    ],
                  ),
                ),
              ),
              buildTextRow(' ', Theme.of(context).textTheme.normal),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextRow(
                        product.insSTDProductUOM ?? '',
                        Theme.of(context).textTheme.normal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (index != indexmax)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
          ),
      ],
    );
  }

  Widget buildProductPortraitRow(BuildContext context, ProductList product, num index, num indexmax) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index.toString()}.',
                    style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.insSTDProductName}',
                        style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                '${product.insSTDProductUsed ?? 0} ',
                                style: Theme.of(context).textTheme.normal,
                              ),
                            ),
                            WidgetSpan(
                              child: Text(
                                '${product.insSTDProductUOM}',
                                style: Theme.of(context).textTheme.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (index != indexmax)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
          ),
      ],
    );
  }

  Widget buildStandard(BuildContext context, List<StandardList> standardList) {
    if (standardList == null || standardList.length == 0) {
      return SizedBox.shrink();
    }

    choice++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: colorDark,
                radius: 16,
                child: Text(
                  '${choice.toString()}',
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   width: 30,
            //   alignment: Alignment.centerLeft,
            //   child: Ink(
            //     padding: EdgeInsets.all(8),
            //     decoration: new BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: colorDark,
            //     ),
            //     child: buildTextRow(
            //       '${choice.toString()}',
            //       Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildTextRow(
                'text.condition_install'.tr(),
                Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5, bottom: 5),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: standardList.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                StandardList standard = standardList[index];
                return buildStandardRow(context, standard);
              }),
        ),
      ],
    );
  }

  Widget buildStandardRow(BuildContext context, StandardList standard) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Text(
              '${standard.insStandardName} ',
              style: Theme.of(context).textTheme.normal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          WidgetSpan(
            child: InkWell(
              child: buildTextRow(
                StringUtil.isNullOrEmpty(standard.insStandardDetail) ? '' : 'text.read_more'.tr(),
                Theme.of(context).textTheme.normal.copyWith(
                      decoration: TextDecoration.underline,
                      color: colorBlue7,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: StringUtil.isNullOrEmpty(standard.insStandardDetail)
                  ? null
                  : () {
                      DialogUtil.showCustomDialog(
                        context,
                        child: StandardDetailPanel(standard: standard),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextRow(String text, TextStyle style) {
    return Text(
      text,
      style: style,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
    );
  }

  Widget buildPrice(BuildContext context, GetArticleRs.ArticleList articleDetail) {
    String normalPrice = StringUtil.getDefaultCurrencyFormat(articleDetail.unitList[0].normalPrice);

    if (articleDetail.isHaveSpecialPrice()) {
      String specialPrice = StringUtil.getDefaultCurrencyFormat(articleDetail.unitList[0].promotionPrice);

      return RichText(
        text: TextSpan(
          children: [
            if (articleDetail.isHaveSpecialPrice())
              WidgetSpan(
                child: buildTextRow(
                  '$normalPrice',
                  Theme.of(context).textTheme.normal.copyWith(color: colorDark),
                ),
              ),
            WidgetSpan(
              child: buildTextRow(' ', Theme.of(context).textTheme.normal),
            ),
            WidgetSpan(
              child: buildTextRow(
                '$specialPrice',
                Theme.of(context).textTheme.normal.copyWith(color: colorDark),
              ),
            ),
            WidgetSpan(
              child: buildTextRow(' ', Theme.of(context).textTheme.normal),
            ),
            WidgetSpan(
              child: buildTextRow(
                'text.baht'.tr(),
                Theme.of(context).textTheme.normal.copyWith(color: colorDark),
              ),
            ),
          ],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: buildTextRow(
              '$normalPrice',
              Theme.of(context).textTheme.small,
            ),
          ),
          WidgetSpan(
            child: buildTextRow(' ', Theme.of(context).textTheme.small),
          ),
          WidgetSpan(
            child: buildTextRow(
              'text.baht'.tr(),
              Theme.of(context).textTheme.small,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonBack(BuildContext context, CheckListInfo checkListInfo) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              primary: colorAccent,
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'text.back'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtonClose(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            primary: colorGrey1,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'common.dialog_button_close'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }

  bool isEnableOKButton() {
    bool haveResidence = widget.checkListData.checkListInfo.residenceList != null && widget.checkListData.checkListInfo.residenceList.length > 0 ? true : false;
    bool havePattern = widget.checkListData.checkListInfo.patternTypeList != null && widget.checkListData.checkListInfo.patternTypeList.length > 0 ? true : false;
    return (haveResidence && StringUtil.isNullOrEmpty(dataSelected.residenceSelected)) || (havePattern && StringUtil.isNullOrEmpty(dataSelected.patternTypeSelected)) || !isConfirmCondition;
  }

  void onConfirm() {
    if (StringUtil.isNotEmpty(dataSelected.patternTypeSelected)) {
      PatternList pattern = widget.checkListData.checkListInfo.patternTypeList.firstWhere((element) => dataSelected.patternTypeSelected == element.insPatternID, orElse: () => null);
      if (!pattern.checkHaveSearchArticle()) {
        onPatternInvalid(pattern.insPatternName);
        return;
      }
    }

    if (StringUtil.isNotEmpty(dataSelected.patternAreaSelected)) {
      PatternList pattern = widget.checkListData.checkListInfo.patternAreaList.firstWhere((element) => dataSelected.patternAreaSelected == element.insPatternID, orElse: () => null);
      if (!pattern.checkHaveSearchArticle()) {
        onPatternInvalid(pattern.insPatternName);
        return;
      }
    }

    CheckListData checkListData = new CheckListData(
      checkListInfo: widget.checkListData.checkListInfo,
      residenceSelected: dataSelected.residenceSelected,
      patternTypeSelected: dataSelected.patternTypeSelected,
      patternAreaSelected: dataSelected.patternAreaSelected,
      isConfirmCondition: isConfirmCondition,
    );

    Navigator.pop(context, checkListData);
  }

  void onPatternInvalid(String patternName) {
    DialogUtil.showCustomDialog(
      context,
      isShowCloseButton: false,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 300,
        child: Column(
          children: [
            Text(
              'text.title.warning'.tr(),
              style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'text.checklist_pattern_name_invalid'.tr(args: [patternName]),
              style: Theme.of(context).textTheme.normal,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: colorBlue7,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'common.dialog_button_ok'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonOK(BuildContext context, CheckListInfo checkListInfo) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              primary: colorBlue7,
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: isEnableOKButton() ? null : onConfirm,
            child: Text(
              'common.dialog_button_ok'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLinkExcessProduct(BuildContext context) {
    return BlocListener<ChecklistInformationExcessBloc, ChecklistInformationExcessState>(
      listener: (context, state) async {
        if (state is ErrorCheckListInformationExcessState) {
          DialogUtil.showErrorDialog(context, state.error);
        } else if (state is SuccessGetExcessProductState) {
          GetExcessProductRs.GetExcessProductRs excessProductRs;
          excessProductRs = state.getExcessProductRs;

          onViewExcessProduct(context, excessProductRs);
        }
      },
      child: InkWell(
        child: buildTextRow(
          '${'text.view_excess_equipment'.tr()} >',
          Theme.of(context).textTheme.normal.copyWith(
                decoration: TextDecoration.underline,
                color: colorBlue7,
                fontWeight: FontWeight.bold,
              ),
        ),
        onTap: () {
          BlocProvider.of<ChecklistInformationExcessBloc>(context).add(
            GetExcessProductEvent(mch: widget.articleDetail.mch9),
          );
        },
      ),
    );
  }

  void onViewExcessProduct(BuildContext context, GetExcessProductRs.GetExcessProductRs excessProductRs) {
    DialogUtil.showCustomDialog(
      context,
      child: ExcessProductPanel(
        excessProductRs: excessProductRs,
      ),
    );
  }

  Widget buildInfoButton(BuildContext context, List<PicList> picList) {
    if (picList == null || picList.length == 0) {
      return Container();
    }

    return InkWell(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.info_outline, color: colorGrey1, size: 35),
          ],
        ),
      ),
      onTap: () => onTapInfoButton(picList),
    );
  }
}

class ExcessProductPanel extends StatefulWidget {
  final GetExcessProductRs.GetExcessProductRs excessProductRs;

  ExcessProductPanel({this.excessProductRs});

  _ExcessProductPanel createState() => _ExcessProductPanel();
}

class _ExcessProductPanel extends State<ExcessProductPanel> with TickerProviderStateMixin {
  bool isLandScape = true;
  double popupWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width) {
      isLandScape = false;
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
    } else {
      isLandScape = true;
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
    }

    return buildDialogExcessProduct();
  }

  Widget buildDialogExcessProduct() {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

    if (widget.excessProductRs?.productGPList?.length == 0) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'text.title.warning'.tr(),
              style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('common.msg.data_not_found'.tr(args: ['text.price_excess_equipment'.tr()]), style: Theme.of(context).textTheme.normal),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: colorBlue7,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'common.dialog_button_close'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      width: 800,
      height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'text.price_excess_equipment'.tr(),
              style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: isLandScape ? const EdgeInsets.symmetric(horizontal: 80.0, vertical: 5) : const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: widget.excessProductRs?.productGPList?.length,
                itemBuilder: (context, index) {
                  GetExcessProductRs.ProductGPList productGroup = widget.excessProductRs?.productGPList[index];
                  return buildExcessGroupRow(context, productGroup, index + 1);
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: 480,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: colorBlue7,
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'common.dialog_button_close'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExcessGroupRow(BuildContext context, GetExcessProductRs.ProductGPList productGP, num index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: const Divider(height: 1, thickness: 2, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  '${index.toString()}. ${productGP.insProductGPName}',
                  style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: const Divider(height: 1, thickness: 2, indent: 0, endIndent: 0),
        ),
        Padding(
          padding: isLandScape ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5) : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: productGP?.productList?.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                GetExcessProductRs.ProductList productGroup = productGP?.productList[index];
                return isLandScape ? buildExcessProductLandScapeRow(productGroup, index + 1, productGP?.productList?.length) : buildExcessProductPortraitRow(productGroup, index + 1, productGP?.productList?.length);
              }),
        ),
      ],
    );
  }

  Widget buildExcessProductLandScapeRow(GetExcessProductRs.ProductList product, num index, num indexmax) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Text(
                  '${index.toString()}. ${product.insSTDProductName}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  product.insSTDProductUOM,
                  style: Theme.of(context).textTheme.normal,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${StringUtil.getDefaultCurrencyFormat(product.insSTDProductCost ?? 0)}.-',
                    style: Theme.of(context).textTheme.normal,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (index != indexmax)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: const Divider(height: 1, thickness: 2, indent: 0, endIndent: 0),
          ),
      ],
    );
  }

  Widget buildExcessProductPortraitRow(GetExcessProductRs.ProductList product, num index, num indexmax) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index.toString()}.',
                    style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.insSTDProductName}',
                        style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                '${product.insSTDProductUOM} ',
                                style: Theme.of(context).textTheme.normal,
                              ),
                            ),
                            WidgetSpan(
                              child: Text(
                                '${StringUtil.getDefaultCurrencyFormat(product.insSTDProductCost ?? 0)}.-',
                                style: Theme.of(context).textTheme.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (index != indexmax)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: const Divider(height: 1, thickness: 2, indent: 0, endIndent: 0),
          ),
      ],
    );
  }
}

class DialogCustomPanel extends StatefulWidget {
  final double width;
  final double height;
  final String header;
  final String detail;

  DialogCustomPanel({this.width, this.height, this.header, this.detail});

  _DialogCustomPanel createState() => _DialogCustomPanel();
}

class _DialogCustomPanel extends State<DialogCustomPanel> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildDialog();
  }

  Widget buildDialog() {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              widget.header,
              style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0)),
              Expanded(
                child: Text(
                  widget.detail,
                  style: Theme.of(context).textTheme.normal,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: colorGrey1,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      'common.dialog_button_close'.tr(),
                      style: Theme.of(context).textTheme.large.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StandardDetailPanel extends StatefulWidget {
  final StandardList standard;

  StandardDetailPanel({this.standard});

  _StandardDetailPanel createState() => _StandardDetailPanel();
}

class _StandardDetailPanel extends State<StandardDetailPanel> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildDialogStandard();
  }

  Widget buildDialogStandard() {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

    if (widget.standard == null) {
      return Container();
    }

    return Container(
      width: 800,
      height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
      child: Column(
        children: [
          buildHeader(context),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                buildHtmlContent(context),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            width: 480,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: colorBlue7,
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'common.dialog_button_close'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      child: Text(
        widget.standard.insStandardName,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildHtmlContent(BuildContext context) {
    if (StringUtil.isNullOrEmpty(widget.standard.insStandardDetail)) {
      return Container();
    }

    return CustomHtml(htmlInput: widget.standard.insStandardDetail);
  }
}

class ViewInfoImagePanel extends StatefulWidget {
  final List<PicList> listImg;

  ViewInfoImagePanel(this.listImg);

  _ViewInfoImagePanel createState() => _ViewInfoImagePanel();
}

class _ViewInfoImagePanel extends State<ViewInfoImagePanel> {
  List<Widget> _cacheImages;
  String currentSelectedImg;
  num selectImageIndex = 0;

  onChangeImage(num index, String currentImg) {
    setState(() {
      currentSelectedImg = currentImg;
      selectImageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _cacheImages = getImages(widget.listImg);
    currentSelectedImg = widget.listImg[selectImageIndex].picUrl;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;

    return Container(
      height: isPortrait ? MediaQuery.maybeOf(context).size.height * 0.5 : MediaQuery.maybeOf(context).size.height * 0.8,
      width: MediaQuery.maybeOf(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
        child: Column(
          children: [
            Expanded(
              flex: 11,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                imageProvider: NetworkImage(
                  ImageUtil.getFullURL(currentSelectedImg),
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/non_article_image.png');
                },
              ),
            ),
            if (widget.listImg.length > 1)
              Container(
                height: 100,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: buildImgChild(widget.listImg),
                  ),
                ),
              ),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }

  List<Widget> buildImgChild(List<PicList> picList) {
    List<Widget> resultWidget = [];

    for (int i = 0; i < picList.length; i++) {
      resultWidget.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          elevation: 8,
          child: Container(
            height: 100,
            width: 100,
            child: _cacheImages[i],
          ),
        ),
      ));
    }

    return resultWidget;
  }

  List<Widget> getImages(List<PicList> pathImages) {
    List<Widget> imageResults = [];
    for (var i = 0; i < pathImages.length; i++) {
      String picUrl = pathImages[i].picUrl;

      imageResults.add(
        OutlinedButton(
          onPressed: () => onChangeImage(i, picUrl),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/non_article_image.png',
            image: ImageUtil.getFullURL(picUrl),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/non_article_image.png');
            },
          ),
        ),
      );
    }

    if (imageResults.isEmpty) {
      imageResults.add(
        Image.asset('assets/images/non_article_image.png'),
      );
    }

    return imageResults;
  }
}
