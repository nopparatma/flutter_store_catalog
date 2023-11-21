import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_guide/sales_guide_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_list/search_product_list_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/view/calculator_product_component.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/quantity_control.dart';
import 'package:easy_localization/easy_localization.dart';

import '../router.dart';
import 'custom_back_to_top_button.dart';

class CalculatorProduct extends StatefulWidget {
  final bool isReadOnly;
  final bool isWizardPortrait;
  final CalculatorProductComponent calProductDisplay;

  CalculatorProduct({this.isReadOnly = false, this.isWizardPortrait = false, this.calProductDisplay});

  @override
  _CalculatorProductState createState() => _CalculatorProductState();
}

class _CalculatorProductState extends State<CalculatorProduct> {
  CalculatorRs calculatorRs;
  SearchProductListBloc searchProductListBloc;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
  }

  @override
  dispose() {
    searchProductListBloc?.close();
    super.dispose();
  }

  void onPressedRadioButton(CalProductChoice choiceItem, CalProductAnswer answerItem) {
    setState(() {
      choiceItem.listCalProductAnswer.forEach((e) {
        e.isSelected = (e.component.componentID == answerItem.component.componentID);
      });
    });

    calculateProduct();
  }

  void onPressedSelectProduct() {
    List<GetArticleRqFeatureList> featureList = []..add(GetArticleRqFeatureList(calculatorRs.featureCode, featureDesc: (calculatorRs.resultCalculator ?? 0).toString()));
    List<MCHList> mCHList = calculatorRs.mchs?.map((e) => MCHList(e))?.toList();

    searchProductListBloc.add(
      SearchMchProductItemFilterEvent(GetArticleRq(featureList: featureList, mCHList: mCHList), null),
    );
  }

  void onCloseDialogCalProduct() {
    Navigator.pop(context);
  }

  bool isNotCompleteSelect() {
    for (CalProductChoice choice in widget.calProductDisplay.listCalProductChoice) {
      if (choice.listCalProductAnswer.any((e) => ComponentType.RADIOBUTTON == e.component.componentType) && choice.listCalProductAnswer.where((e) => ComponentType.RADIOBUTTON == e.component.componentType && e.isSelected).length == 0) {
        return true;
      }
      if (choice.listCalProductAnswer.any((e) => ComponentType.TEXTBOX == e.component.componentType) && choice.listCalProductAnswer.where((e) => ComponentType.TEXTBOX == e.component.componentType && e.value == 0).length > 0) {
        return true;
      }
    }

    return false;
  }

  void calculateProduct() {
    // Validate Complete Select
    if (isNotCompleteSelect()) return;

    BlocProvider.of<SalesGuideBloc>(context).add(
      CalculateProductEvent(componentDisplay: widget.calProductDisplay),
    );
  }

  onSearchDataNotFound() {
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
            Text('text.not_found_product'.tr(), style: Theme.of(context).textTheme.normal),
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
                      onCloseDialogCalProduct();
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
      ),
    );
  }

  onSearchDataFound() async {
    var isCloseFromProducts = await Navigator.of(context).pushNamed(WebRoutePaths.Products, arguments: {'calculatorRs': calculatorRs});

    if (isCloseFromProducts ?? false) {
      // กลับไปหน้า ก่อนจะเข้าหน้านี้
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchProductListBloc = SearchProductListBloc(BlocProvider.of<ApplicationBloc>(context)),
      child: BlocListener<SearchProductListBloc, SearchProductListState>(
        condition: (prevState, currentState) {
          if (prevState is LoadingProductItemState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) async {
          if (state is LoadingProductItemState) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is ErrorMchProductItemState) {
            await DialogUtil.showErrorDialog(context, state.error);
          } else if (state is SearchMchProductItemFilterState) {
            if (state.getArticleRs.totalSize == 0) {
              onSearchDataNotFound();
            } else {
              onSearchDataFound();
            }
          }
        },
        child: buildMainContent(),
      ),
    );
  }

  Widget buildMainContent() {
    if (widget.isReadOnly) {
      bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;
      return Container(
        width: 800,
        height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
        child: buildDetailContent(),
      );
    }

    return buildDetailContent();
  }

  Widget buildDetailContent() {
    if (widget?.calProductDisplay?.listCalProductChoice == null || widget?.calProductDisplay?.listCalProductChoice?.length == 0) return Container();

    if (widget.isWizardPortrait) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: buildItemContent(),
      );
    }

    if (widget.isReadOnly) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: buildItemContent(),
      );
    } else {
      return Scaffold(
        body: ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          children: [
            buildItemContent(),
          ],
        ),
        floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
      );
    }
  }

  Widget buildItemContent() {
    String calculatorName = LanguageUtil.isTh(context) ? widget.calProductDisplay.calculatorNameTH : widget.calProductDisplay.calculatorNameEN;

    return Column(
      children: [
        buildLabel(text: calculatorName, isHeader: true),
        widget.isReadOnly
            ? Expanded(
                child: ListView(
                  children: [
                    buildMiddleContent(),
                  ],
                ),
              )
            : buildMiddleContent(),
        buildButtonFooter(),
      ],
    );
  }

  Widget buildMiddleContent() {
    return Column(
      children: [
        ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.calProductDisplay.listCalProductChoice.length,
          itemBuilder: (context, index) {
            CalProductChoice choiceItem = widget.calProductDisplay.listCalProductChoice[index];
            return buildChoice(choiceItem);
          },
        ),
        buildLabel(text: 'text.result'.tr(), seq: widget.calProductDisplay.listCalProductChoice.last.seq + 1),
        buildSummary(),
      ],
    );
  }

  Widget buildChoice(CalProductChoice choiceItem) {
    return Container(
      child: Column(
        children: [
          buildLabel(seq: choiceItem.seq, text: choiceItem.title),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: choiceItem.listCalProductAnswer.length,
            itemBuilder: (context, index) {
              CalProductAnswer answerItem = choiceItem.listCalProductAnswer[index];
              if (ComponentType.RADIOBUTTON == answerItem.component.componentType) {
                return buildRadioButton(choiceItem, answerItem);
              } else if (ComponentType.TEXTBOX == answerItem.component.componentType) {
                return buildTextBox(answerItem);
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget buildLabel({String text, num seq = 0, bool isHeader = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: (isHeader && widget.isReadOnly) ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (!isHeader)
            Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: colorDark,
                radius: 16,
                child: Text(
                  '$seq',
                  style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: isHeader ? Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark) : Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildRadioButton(CalProductChoice choiceItem, CalProductAnswer answerItem) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(left: 40, right: 4, top: 4, bottom: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: 4,
                backgroundColor: answerItem.isSelected ? colorBlue5 : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(
                  width: 1,
                  color: answerItem.isSelected ? colorBlue7 : Colors.white,
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        border: Border.all(color: colorDark, width: 1),
                      ),
                      child: Text(
                        '${answerItem.component.seq}',
                        style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      answerItem.component.componentName,
                      style: Theme.of(context).textTheme.normal.copyWith(color: colorDark),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                onPressedRadioButton(choiceItem, answerItem);
              },
            ),
          ),
        ),
        Expanded(flex: widget.isReadOnly ? 0 : 1, child: Container()),
      ],
    );
  }

  Widget buildTextBox(CalProductAnswer answerItem) {
    return Container(
      margin: const EdgeInsets.only(left: 40, top: 4, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Text(
                  '${answerItem.component.componentName}',
                  style: Theme.of(context).textTheme.normal.copyWith(color: colorDark, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                ),
                Text(
                  ' (${answerItem.component.unit})',
                  style: Theme.of(context).textTheme.normal.copyWith(color: colorDark),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            children: [
              QuantityControl(
                incrValue: 1,
                minValue: 0,
                maxValue: 9999,
                isDecimal: true,
                callBackIncr: (val) {
                  setState(() => answerItem.value = val);
                  calculateProduct();
                },
                callBackDecr: (val) {
                  setState(() => answerItem.value = val);
                  calculateProduct();
                },
                callBackChange: (val) {
                  setState(() => answerItem.value = val);
                  calculateProduct();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummary() {
    return BlocBuilder<SalesGuideBloc, SalesGuideState>(
      condition: (previous, current) {
        return (current is InitialSalesGuideState || current is CalculateProductSuccessState);
      },
      builder: (context, state) {
        if (state is CalculateProductSuccessState) {
          CalculatorRs rs = state.calculatorRs;
          num resultCal = rs?.resultCalculator ?? 0;
          String beforeResultText = (LanguageUtil.isTh(context) ? rs?.beforeResultTextTh : rs?.beforeResultTextEn) ?? '';
          String afterResultText = (LanguageUtil.isTh(context) ? rs?.afterResultTextTh : rs?.afterResultTextEn) ?? '';
          String remark = (LanguageUtil.isTh(context) ? rs?.remarkTh : rs?.remarkEn) ?? '';

          return Container(
            margin: const EdgeInsets.only(left: 42, top: 4, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            beforeResultText,
                            style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Text(
                            StringUtil.toStringFormat(resultCal, '#,##0'),
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold, color: colorGreen2),
                          ),
                          SizedBox(width: 8),
                          Text(
                            afterResultText,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(remark, style: Theme.of(context).textTheme.normal),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(height: 60);
      },
    );
  }

  Widget buildButtonFooter() {
    if (widget.isReadOnly) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                onCloseDialogCalProduct();
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

    return BlocBuilder<SalesGuideBloc, SalesGuideState>(
      condition: (previous, current) {
        return (current is InitialSalesGuideState || current is CalculateProductSuccessState);
      },
      builder: (context, state) {
        if (state is CalculateProductSuccessState) {
          calculatorRs = state.calculatorRs;
          return buildButtonSelectProduct(isEnable: true);
        }

        return buildButtonSelectProduct(isEnable: false);
      },
    );
  }

  Widget buildButtonSelectProduct({bool isEnable}) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 40, top: 20, bottom: 60),
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              primary: colorBlue7,
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'text.select_product_model'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
            ),
            onPressed: isEnable ? () => onPressedSelectProduct() : null,
          ),
        ),
      ],
    );
  }
}

// List<Calculator> listGetCalculatorRs = [
//   Calculator(
//     calculatorId: 'C12',
//     calculatorNameTH: 'คำนวนขนาดของแท้งค์น้ำ',
//     calculatorNameEN: 'Water tank calculator',
//     component: [
//       Component(line: 1, componentList: [ComponentList(seq: 1, componentID: "7", componentName: "ประเภทของแท้งน้ำ", componentType: ComponentType.LABEL, defaultValue: null, unit: null, toolTip: "ประเภทของแท้ง")]),
//       Component(line: 2, componentList: [ComponentList(seq: 1, componentID: "8", componentName: "แท้งน้ำบนดิน", componentType: ComponentType.RADIOBUTTON, defaultValue: 1, unit: null, toolTip: "แท้งน้ำบนดิน")]),
//       Component(line: 3, componentList: [ComponentList(seq: 1, componentID: "9", componentName: "แท้งน้ำใต้ดิน", componentType: ComponentType.RADIOBUTTON, defaultValue: 2, unit: null, toolTip: "แท้งน้ำใต้ดิน")]),
//       Component(line: 4, componentList: [ComponentList(seq: 1, componentID: "10", componentName: "จำนวนผู้พักอาศัย", componentType: ComponentType.LABEL, defaultValue: null, unit: null, toolTip: "จำนวนผู้พักอาศัย")]),
//       Component(line: 5, componentList: [ComponentList(seq: 1, componentID: "11", componentName: "1-2 คน", componentType: ComponentType.RADIOBUTTON, defaultValue: 1, unit: null, toolTip: "1-2 คน")]),
//       Component(line: 6, componentList: [ComponentList(seq: 1, componentID: "12", componentName: "3-4 คน", componentType: ComponentType.RADIOBUTTON, defaultValue: 2, unit: null, toolTip: "3-4 คน")]),
//       Component(line: 7, componentList: [ComponentList(seq: 1, componentID: "13", componentName: "5-6 คน", componentType: ComponentType.RADIOBUTTON, defaultValue: 3, unit: null, toolTip: "5-6 คน")]),
//       Component(line: 8, componentList: [ComponentList(seq: 1, componentID: "28", componentName: "ตัวอย่างการพิมพ์ตัวเลข", componentType: ComponentType.LABEL, defaultValue: null, unit: null, toolTip: "ตัวอย่างการพิมพ์ตัวเลข")]),
//       Component(line: 9, componentList: [ComponentList(seq: 1, componentID: "29", componentName: "กว้าง", componentType: ComponentType.TEXTBOX, defaultValue: null, unit: "เมตร", toolTip: "กรุณาระบุตัวเลข")]),
//       Component(line: 10, componentList: [ComponentList(seq: 1, componentID: "29", componentName: "ยาว", componentType: ComponentType.TEXTBOX, defaultValue: null, unit: "เมตร", toolTip: "กรุณาระบุตัวเลข")]),
//     ],
//   )
// ];
