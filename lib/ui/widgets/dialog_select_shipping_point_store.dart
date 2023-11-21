import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/order/order_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/shipping_point_store/shipping_point_store_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/models/view/store_zone.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_solid_icon_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/widgets/search_result_text.dart';
import 'package:flutter_store_catalog/ui/widgets/shipping_point_store_item.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';

import 'dialog_out_of_area.dart';

class DialogSelectShippingPointStore extends StatefulWidget {
  _DialogSelectShippingPointStoreState createState() => _DialogSelectShippingPointStoreState();
}

class _DialogSelectShippingPointStoreState extends State<DialogSelectShippingPointStore> {
  TextEditingController searchTextController;
  ShippingPointList shippingPointSelected;
  List<ShippingPointList> lstMainShippingPointStore;
  ShippingPointStoreBloc shippingPointStoreBloc;
  String regionSelected;
  List<StoreZone> listOptionsZone;

  @override
  void initState() {
    super.initState();

    shippingPointSelected = ShippingPointList();
    lstMainShippingPointStore = [];
    listOptionsZone = [];
    regionSelected = TypeOfStoreZone.ALL;

    searchTextController = TextEditingController();
    searchTextController.addListener(() {
      setState(() {
        onSearch();
      });
    });
  }

  @override
  void dispose() {
    shippingPointStoreBloc?.close();
    super.dispose();
  }

  void onPressedSelect() {
    Navigator.of(context).pop(shippingPointSelected);
  }

  void onPressedShippingPoint(ShippingPointList shippingPoint) {
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      shippingPointSelected = shippingPoint;
    });
  }

  void onSearch() {
    shippingPointSelected = ShippingPointList();
    shippingPointStoreBloc.add(
      FilterShippingPointStoreEvent(region: regionSelected, name: searchTextController.text, lstMainShippingPointStore: lstMainShippingPointStore),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

    return BlocProvider<ShippingPointStoreBloc>(
      create: (context) {
        return shippingPointStoreBloc = ShippingPointStoreBloc(BlocProvider.of<ApplicationBloc>(context), BlocProvider.of<SalesCartBloc>(context))
          ..add(
            SearchShippingPointStoreEvent(),
          );
      },
      child: BlocListener<ShippingPointStoreBloc, ShippingPointStoreState>(
        condition: (prevState, currentState) {
          if (prevState is LoadingShippingPointStoreState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) async {
          if (state is LoadingShippingPointStoreState) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is ErrorShippingPointStoreState) {
            await DialogUtil.showErrorDialog(context, state.error);
          }
        },
        child: Container(
          width: 800,
          height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              buildHeader(),
              buildHeaderSearch(),
              buildContent(),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('text.select_store_receive_product'.tr(), style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget buildHeaderSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text('text.select_region'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorDark)),
                ),
                SizedBox(
                  height: 49,
                  child: BlocBuilder<ShippingPointStoreBloc, ShippingPointStoreState>(
                    builder: (context, state) {
                      if (state is SuccessSearchShippingPointStoreState) {
                        listOptionsZone = state.listOptionsZone;
                      }

                      List<DropdownMenuItem> lstOptionsRegion = [];
                      if (listOptionsZone != null && listOptionsZone.length > 0) {
                        listOptionsZone.forEach((e) {
                          lstOptionsRegion.add(DropdownMenuItem(child: Text(e.zoneName), value: e.zoneCode));
                        });
                      } else {
                        lstOptionsRegion.add(DropdownMenuItem(child: Text('text.select_all'.tr()), value: TypeOfStoreZone.ALL));
                      }

                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: colorGrey1,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        value: regionSelected,
                        items: lstOptionsRegion,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        onChanged: (val) {
                          setState(() {
                            regionSelected = val;
                            onSearch();
                          });
                        },
                        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text('text.search_store'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorDark)),
                ),
                VirtualKeyboardWrapper(
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
                        hintText: 'text.search_store_name'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            width: 1,
                            color: colorGrey1,
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        onSearch();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
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
        onPressed: shippingPointSelected?.shippingPointId != null ? () => onPressedSelect() : null,
        child: Text('text.pick_up_at_store'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget buildContent() {
    return Expanded(
      child: BlocBuilder<ShippingPointStoreBloc, ShippingPointStoreState>(
        builder: (context, state) {
          if (state is SuccessSearchShippingPointStoreState) {
            lstMainShippingPointStore = state.lstShippingPointStore;
            return buildContentItem(lstMainShippingPointStore);
          } else if (state is SuccessFilterShippingPointStoreState) {
            return buildContentItem(state.lstShippingPointStoreFilter);
          }

          return Container();
        },
      ),
    );
  }

  Widget buildContentItem(List<ShippingPointList> lstShippingPoint) {
    if (lstShippingPoint == null || lstShippingPoint.length == 0) {
      return SearchResultText(result: 0, searchText: searchTextController.text);
    }

    return ListView(
      children: [
        StaggeredGridView.count(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(5),
          crossAxisCount: 4,
          shrinkWrap: true,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: lstShippingPoint
              .map((e) => ShippingPointStoreItem(
                    shippingPointStore: e,
                    isSelected: shippingPointSelected == e,
                    onPressedShippingPoint: onPressedShippingPoint,
                  ))
              .toList(),
          staggeredTiles: lstShippingPoint.map((e) => StaggeredTile.fit(2)).toList(),
        ),
      ],
    );
  }
}
