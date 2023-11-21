import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rq.dart' as CalculatorRq;
import 'package:flutter_store_catalog/core/models/dotnet/calculator_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_calculator_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_calculator_rs.dart' as GetCalculatorRs;
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rs.dart';
import 'package:flutter_store_catalog/core/models/view/calculator_product_component.dart';
import 'package:flutter_store_catalog/core/services/dotnet/calculator_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/product_knowledge_service.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/get_it.dart';

part 'sales_guide_event.dart';

part 'sales_guide_state.dart';

class SalesGuideBloc extends Bloc<SalesGuideEvent, SalesGuideState> {
  final ApplicationBloc applicationBloc;
  final ProductKnowledgeService _productKnowledgeService = getIt<ProductKnowledgeService>();
  final CalculatorService _calculatorService = getIt<CalculatorService>();

  SalesGuideBloc(this.applicationBloc);

  @override
  SalesGuideState get initialState => InitialSalesGuideState();

  @override
  Stream<SalesGuideState> mapEventToState(SalesGuideEvent event) async* {
    if (event is SalesGuideLoadEvent) {
      yield* mapSalesGuideLoadEventToState(event);
    } else if (event is CalculateProductEvent) {
      yield* mapCalculateProductEventToState(event);
    } else if (event is KnowledgeHtmlContentEvent) {
      yield* mapKnowledgeHtmlContentEventToState(event);
    }
  }

  Stream<SalesGuideState> mapSalesGuideLoadEventToState(SalesGuideLoadEvent event) async* {
    try {
      yield LoadingSalesGuideState();

      GetProductKnowledgeRs getProductKnowledgeRs = GetProductKnowledgeRs();

      if (event.knowledgeIdList != null && event.knowledgeIdList.length > 0) {
        GetProductKnowledgeRq rq = GetProductKnowledgeRq()
          ..mch = event.mch
          ..knowledgeIdList = event.knowledgeIdList;
        getProductKnowledgeRs = await _productKnowledgeService.getProductKnowledge(rq);
      }

      CalculatorProductComponent calDisplay = CalculatorProductComponent();
      if (!StringUtil.isNullOrEmpty(event.calculatorId)) {
        GetCalculatorRq rq = GetCalculatorRq()
          ..mch = event.mch
          ..calculatorId = event.calculatorId;

        GetCalculatorRs.GetCalculatorRs getCalculatorRs = await _calculatorService.getCalculator(rq);

        // Convert to Display
        calDisplay = convertRsToDisplay(getCalculatorRs);
      }

      yield SalesGuideLoadSuccessState(knowledgeList: getProductKnowledgeRs?.knowledgeList, calculateProductDisplay: calDisplay);
    } catch (error, stackTrace) {
      yield ErrorSalesGuideState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<SalesGuideState> mapCalculateProductEventToState(CalculateProductEvent event) async* {
    try {
      yield LoadingSalesGuideState();

      List<CalculatorRq.ComponentList> listComponent = [];
      event.componentDisplay.listCalProductChoice.forEach((choice) {
        choice.listCalProductAnswer.forEach((answer) {
          CalculatorRq.ComponentList component = CalculatorRq.ComponentList();
          component.componentID = answer.component.componentID;
          component.componentValue = (ComponentType.RADIOBUTTON == answer.component.componentType && answer.isSelected)
              ? answer.component.defaultValue
              : (ComponentType.TEXTBOX == answer.component.componentType)
                  ? answer.value
                  : 0;
          listComponent.add(component);
        });
      });

      CalculatorRq.Calculator calculator = CalculatorRq.Calculator()
        ..calculatorId = event.componentDisplay.calculatorId
        ..componentList = listComponent;

      CalculatorRs rs = await _calculatorService.calculator(CalculatorRq.CalculatorRq()..calculator = calculator);

      yield CalculateProductSuccessState(calculatorRs: rs);
    } catch (error, stackTrace) {
      yield ErrorSalesGuideState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<SalesGuideState> mapKnowledgeHtmlContentEventToState(KnowledgeHtmlContentEvent event) async* {
    try {
      yield LoadingSalesGuideState();

      String htmlContent = await _productKnowledgeService.getProductKnowledgeHTMLContent(event.knowledgeId);

      yield KnowledgeHtmlContentSuccessState(htmlContent: htmlContent);
    } catch (error, stackTrace) {
      yield ErrorSalesGuideState(AppException(error, stackTrace: stackTrace));
    }
  }

  CalculatorProductComponent convertRsToDisplay(GetCalculatorRs.GetCalculatorRs rs) {
    CalculatorProductComponent calDisplay = CalculatorProductComponent();

    if (rs.calculator != null && rs.calculator.length > 0) {
      GetCalculatorRs.Calculator calculator = rs.calculator.first;

      calDisplay.calculatorId = calculator.calculatorId;
      calDisplay.calculatorNameTH = calculator.calculatorNameTH;
      calDisplay.calculatorNameEN = calculator.calculatorNameEN;

      // Add Topic
      calDisplay.listCalProductChoice = [];
      num seqTopic = 0;
      for (num k = 0; k < calculator.component.length; k++) {
        GetCalculatorRs.ComponentList componentItem = calculator.component[k].componentList.first;
        if (ComponentType.LABEL == componentItem.componentType) {
          CalProductChoice topic = CalProductChoice()
            ..line = calculator.component[k].line
            ..seq = ++seqTopic
            ..title = componentItem.componentName;
          calDisplay.listCalProductChoice.add(topic);

          // Add Answer
          CalProductChoice topicLast = calDisplay.listCalProductChoice.last;
          topicLast.listCalProductAnswer = [];
          num seqAns = 0;
          for (num i = k + 1; i < calculator.component.length; i++) {
            if (ComponentType.LABEL == calculator.component[i].componentList.first.componentType) break;

            CalProductAnswer answer = CalProductAnswer()
              ..component = calculator.component[i].componentList.first
              ..component.seq = ++seqAns
              ..isSelected = false;
            topicLast.listCalProductAnswer.add(answer);
          }
        }
      }
    }

    return calDisplay;
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
