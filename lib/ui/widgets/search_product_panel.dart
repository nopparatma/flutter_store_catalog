import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_keyboard/flag_keyboard_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_product_list/search_product_list_bloc.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/search_result_text.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/text_formatter.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';

import '../router.dart';

class SearchProductPanel extends StatefulWidget {
  @override
  _SearchProductPanelState createState() => _SearchProductPanelState();
}

class _SearchProductPanelState extends State<SearchProductPanel> {
  TextEditingController searchTextController;
  OverlayEntry _overlay;
  GlobalKey _searchPanelKey = GlobalKey();
  LayerLink _layerLink = LayerLink();

  SearchProductListBloc searchProductListBloc;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    searchTextController?.dispose();
    _overlay?.dispose();
    searchProductListBloc?.close();

    super.dispose();
  }

  void onSearchDataNotFound(String searchText) {
    _overlay = _createPanelOverlay(searchText);
    Overlay.of(context).insert(_overlay);
  }

  void onSearchDataFound() {
    Navigator.of(context).pushNamedAndRemoveUntil(WebRoutePaths.Products, (route) {
      // print('===>');
      // print(route);
      // print(route is DialogRoute);
      // print(route.settings.name);
      if (route is DialogRoute) {
        return false;
      }
      if (route.settings.name == WebRoutePaths.Products) {
        return false;
      }

      // return false = close page
      return true;
    }, arguments: {'searchText': searchTextController.text});
    searchTextController.clear();
  }

  onSearch() {
    String searchText = searchTextController.text;
    if (searchText.isEmpty || searchText.length < 2) {
      return;
    }
    FocusScope.of(context).unfocus();
    searchProductListBloc.add(SearchMchProductItemFilterEvent(GetArticleRq(desc: searchText, pageSize: 1), null));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => searchProductListBloc = SearchProductListBloc(BlocProvider.of<ApplicationBloc>(context)),
      child: BlocListener<SearchProductListBloc, SearchProductListState>(
        condition: (prevState, currentState) {
          if (prevState is LoadingProductItemState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) {
          if (state is LoadingProductItemState) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is ErrorMchProductItemState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is SearchMchProductItemFilterState) {
            if (state.getArticleRs.totalSize == 0) {
              onSearchDataNotFound(searchTextController.text);
            } else {
              onSearchDataFound();
            }
          }
        },
        child: Container(
          width: 650,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          // height: 56,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: IntrinsicHeight(
              key: _searchPanelKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: VirtualKeyboardWrapper(
                      textController: searchTextController,
                      maxLength: 50,
                      onKeyPress: (key) {
                        if (key.action == VirtualKeyboardKeyAction.Return) {
                          onSearch();
                        }
                      },
                      builder: (textEditingController, focusNode, inputFormatters) {
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          inputFormatters: inputFormatters,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: searchTextController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () => searchTextController.clear(),
                                    icon: Icon(Icons.clear),
                                  )
                                : null,
                            hintText: '${'text.search_product'.tr()}...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                width: 1,
                                color: colorBlue3,
                              ),
                            ),
                          ),
                          onSubmitted: (value) {
                            onSearch();
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: colorAccent,
                        padding: EdgeInsets.symmetric(horizontal: 36),
                      ),
                      onPressed: () {
                        onSearch();
                      },
                      child: Text('text.search_product'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createPanelOverlay(String searchText) {
    RenderBox renderBox = _searchPanelKey.currentContext.findRenderObject(); // พิกัด และขนาดการ Render ของ Widget นี้
    var size = renderBox.size; // ขนาดของ Widget
    // var offset = renderBox.localToGlobal(Offset.zero); // พิกัด X,Y ที่ Widget นี้แสดงอยู่

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () {
                _overlay?.remove();
              },
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height),
              child: Material(
                child: buildBottomPanel(searchText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomPanel(String searchText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorGrey4,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchResultText(
            result: 0,
            searchText: searchText,
          ),
          Text(
            'text.search_try_again_with_diff_keyword'.tr(),
            style: Theme.of(context).textTheme.small.copyWith(
                  color: colorGrey1,
                ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
