import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_product_knowledge_rs.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_back_to_top_button.dart';

const List<KnowledgeModel> knowledgeStyles = [
  KnowledgeModel(Color(0xFFFFB030)),
  KnowledgeModel(Color(0xFF787878)),
  KnowledgeModel(Color(0xFF3B8EEE)),
  KnowledgeModel(Color(0xFF97C45D)),
  KnowledgeModel(Color(0xFFFFA88D)),
  KnowledgeModel(Color(0xFF2882A4)),
  KnowledgeModel(Color(0xFF787878)),
  KnowledgeModel(Color(0xFF97C45D)),
  KnowledgeModel(Color(0xFF3B8EEE)),
  KnowledgeModel(Color(0xFF2882A4)),
  KnowledgeModel(Color(0xFFFFB030)),
  KnowledgeModel(Color(0xFF97C45D)),
  KnowledgeModel(Color(0xFFFFA88D)),
  KnowledgeModel(Color(0xFF787878)),
];

class KnowledgeProductList extends StatefulWidget {
  final bool isWizardPortrait;
  final List<KnowledgeList> knowledgeList;

  KnowledgeProductList({this.knowledgeList, this.isWizardPortrait = false});

  @override
  _KnowledgeProductListState createState() => _KnowledgeProductListState();
}

class _KnowledgeProductListState extends State<KnowledgeProductList> {
  int limitFirstView;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    limitFirstView = Knowledge.COUNT_INIT_KNOWLEDGE_VIEW;

    scrollController = ScrollController();
  }

  @override
  dispose() {
    super.dispose();
  }

  void onPressedReadMore() {
    setState(() {
      limitFirstView = widget.knowledgeList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (widget.isWizardPortrait)
          return Column(
            children: [
              buildKnowledgeGridView(orientation),
              if (widget.knowledgeList.length > limitFirstView) buildReadMoreButton(),
            ],
          );

        return Scaffold(
          body: ListView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            children: [
              buildKnowledgeGridView(orientation),
            ],
          ),
          floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
        );
      },
    );
  }

  Widget buildKnowledgeGridView(Orientation orientation) {
    return StaggeredGridView.count(
      key: ValueKey<int>(orientation == Orientation.portrait && !widget.isWizardPortrait ? 2 : 4),
      crossAxisCount: orientation == Orientation.portrait && !widget.isWizardPortrait ? 2 : 4,
      shrinkWrap: true,
      primary: false,
      children: widget.knowledgeList?.getRange(0, widget.isWizardPortrait && widget.knowledgeList.length >= limitFirstView ? limitFirstView : widget.knowledgeList.length)?.map((e) {
            KnowledgeModel style = knowledgeStyles[widget.knowledgeList.indexOf(e) % knowledgeStyles.length];
            return KnowledgeTile(style.color, e, widget.isWizardPortrait);
          })?.toList() ??
          [],
      staggeredTiles: widget.knowledgeList?.getRange(0, widget.isWizardPortrait && widget.knowledgeList.length >= limitFirstView ? limitFirstView : widget.knowledgeList.length)?.map((e) {
            return StaggeredTile.count(2, 1);
          })?.toList() ??
          [],
    );
  }

  Widget buildReadMoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 4,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  width: 1,
                  color: colorBlue7,
                  style: BorderStyle.solid,
                ),
              ),
              child: Text(
                'text.see_more_articles'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal, decoration: TextDecoration.underline, color: colorBlue7),
              ),
              onPressed: () {
                onPressedReadMore();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class KnowledgeTile extends StatelessWidget {
  final Color backgroundColor;
  final KnowledgeList knowledge;
  final bool isWizardPortrait;

  const KnowledgeTile(this.backgroundColor, this.knowledge, this.isWizardPortrait);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: 'assets/images/non_article_image.png',
            image: knowledge.picUrl ?? '',
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
                  backgroundColor.withOpacity(0.9),
                  backgroundColor.withOpacity(0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: isWizardPortrait ? const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20) : const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text(
                          knowledge.knowledgeName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.larger.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Expanded(flex: 3, child: Container())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: isWizardPortrait ? const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20) : const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'text.read_more'.tr(),
                  style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal, color: colorBlue7),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    WebRoutePaths.Knowledge,
                    arguments: {
                      'backgroundColor': backgroundColor,
                      'knowledge': knowledge,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class KnowledgeModel {
  final Color color;

  const KnowledgeModel(this.color);
}
