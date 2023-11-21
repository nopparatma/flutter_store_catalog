import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_guide/sales_guide_bloc.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rs.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_store_catalog/ui/views/layout.dart';

import 'custom_back_to_top_button.dart';
import 'custom_html.dart';

class KnowledgePage extends StatefulWidget {
  final Color backgroundColor;
  final KnowledgeList knowledge;

  KnowledgePage({this.backgroundColor, this.knowledge});

  @override
  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  String htmlContent;
  ScrollController scrollController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      isShowBack: true,
      body: BlocProvider<SalesGuideBloc>(
        create: (context) => SalesGuideBloc(BlocProvider.of<ApplicationBloc>(context))..add(KnowledgeHtmlContentEvent(knowledgeId: widget.knowledge.knowledgeId)),
        child: BlocListener<SalesGuideBloc, SalesGuideState>(
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
          child: Scaffold(
            body: OrientationBuilder(
              builder: (context, orientation) {
                return ListView(
                  controller: scrollController,
                  children: [
                    orientation == Orientation.landscape
                        ? Row(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(flex: 3, child: Card(elevation: 5, child: buildMainContent(context))),
                              Expanded(flex: 1, child: Container()),
                            ],
                          )
                        : buildMainContent(context),
                  ],
                );
              },
            ),
            floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
          ),
        ),
      ),
    );
  }

  Widget buildMainContent(BuildContext context) {
    return Column(
      children: [
        buildHeader(context),
        buildHtmlContent(context),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              placeholder: 'assets/images/non_article_image.png',
              image: widget.knowledge.picUrl ?? '',
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/non_article_image.png');
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.backgroundColor.withOpacity(0.9),
                    widget.backgroundColor.withOpacity(0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        widget.knowledge.knowledgeName,
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(flex: 5, child: Container())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHtmlContent(BuildContext context) {
    return BlocBuilder<SalesGuideBloc, SalesGuideState>(
      condition: (previous, current) {
        return (current is InitialSalesGuideState || current is KnowledgeHtmlContentSuccessState);
      },
      builder: (context, state) {
        if (state is KnowledgeHtmlContentSuccessState) {
          return Container(width: 800, child: CustomHtml(htmlInput: state.htmlContent));
        }

        return Container();
      },
    );
  }
}
