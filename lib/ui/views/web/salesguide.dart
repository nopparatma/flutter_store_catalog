import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_guide/sales_guide_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_list/search_product_list_bloc.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_calculator_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/view/calculator_product_component.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';

import '../../router.dart';
import '../../widgets/calculator_product.dart';
import '../../widgets/knowledge_product_list.dart';

class SalesGuidePage extends StatefulWidget {
  final bool isReadOnly;
  final String mch;
  final List<String> knowledgeIdList;
  final String calculatorId;

  const SalesGuidePage({Key key, this.isReadOnly = false, this.mch, this.knowledgeIdList, this.calculatorId}) : super(key: key);

  @override
  _SalesGuidePageState createState() => _SalesGuidePageState();
}

class _SalesGuidePageState extends State<SalesGuidePage> with TickerProviderStateMixin {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SalesGuideBloc>(
          create: (context) {
            return SalesGuideBloc(BlocProvider.of<ApplicationBloc>(context))
              ..add(
                SalesGuideLoadEvent(
                  mch: widget.mch,
                  knowledgeIdList: widget.knowledgeIdList,
                  calculatorId: widget.calculatorId,
                ),
              );
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SalesGuideBloc, SalesGuideState>(
            condition: (prevState, currentState) {
              if (prevState is LoadingSalesGuideState) {
                DialogUtil.hideLoadingDialog(context);
              }
              return true;
            },
            listener: (context, state) async {
              if (state is LoadingSalesGuideState) {
                DialogUtil.showLoadingDialog(context);
              } else if (state is ErrorSalesGuideState) {
                await DialogUtil.showErrorDialog(context, state.error);
              }
            },
          ),
        ],
        child: BlocBuilder<SalesGuideBloc, SalesGuideState>(
          condition: (previous, current) {
            return (current is InitialSalesGuideState || current is SalesGuideLoadSuccessState);
          },
          builder: (context, state) {
            if (state is SalesGuideLoadSuccessState) {
              if ((state.calculateProductDisplay != null && state.calculateProductDisplay.listCalProductChoice != null && state.calculateProductDisplay.listCalProductChoice.length > 0) && widget.isReadOnly) {
                return CalculatorProduct(calProductDisplay: state.calculateProductDisplay, isReadOnly: widget.isReadOnly);
              }

              return CommonLayout(
                isShowBack: true,
                body: OrientationBuilder(
                  builder: (context, orientation) {
                    return buildMainContent(orientation, state.knowledgeList, state.calculateProductDisplay);
                  },
                ),
              );
            }

            // Set Default width,height Dialog
            if (widget.isReadOnly) {
              double maxWidth = 800.0;
              double maxHeight = 800.0;
              double widthDialog = MediaQuery.of(context).size.width * 0.6;
              double heightDialog = MediaQuery.of(context).size.height * 0.85;
              return Container(
                width: widthDialog > maxWidth ? maxWidth : widthDialog,
                height: heightDialog > maxHeight ? maxHeight : heightDialog,
              );
            }

            return CommonLayout(isShowBack: true, body: Container());
          },
        ),
      ),
    );
  }

  Widget buildMainContent(Orientation orientation, List<KnowledgeList> knowledgeList, CalculatorProductComponent calProductDisplay) {
    bool isKnowledge = (knowledgeList != null && knowledgeList.length > 0);
    bool isCalculator = (calProductDisplay != null && calProductDisplay.listCalProductChoice != null && calProductDisplay.listCalProductChoice.length > 0);

    // Wizard Page
    if (isKnowledge && isCalculator) {
      if (Orientation.portrait == orientation) {
        return Scaffold(
          body: ListView(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 80),
            children: [
              KnowledgeProductList(knowledgeList: knowledgeList, isWizardPortrait: true),
              CalculatorProduct(calProductDisplay: calProductDisplay, isWizardPortrait: true),
            ],
          ),
          floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
        );
      } else if (Orientation.landscape == orientation) {
        return Row(
          children: [
            Expanded(
              child: KnowledgeProductList(knowledgeList: knowledgeList),
            ),
            Expanded(
              child: CalculatorProduct(calProductDisplay: calProductDisplay),
            ),
          ],
        );
      }
    }

    if (isKnowledge) {
      return KnowledgeProductList(knowledgeList: knowledgeList);
    }

    if (isCalculator) {
      return CalculatorProduct(calProductDisplay: calProductDisplay, isReadOnly: widget.isReadOnly);
    }

    return Container();
  }
}
