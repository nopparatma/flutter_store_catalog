import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/shipping_point_store/shipping_point_store_bloc.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/shipping_point_store_item.dart';
import 'package:easy_localization/easy_localization.dart';

class DialogOutOfArea extends StatefulWidget {
  _DialogOutOfAreaState createState() => _DialogOutOfAreaState();
}

class _DialogOutOfAreaState extends State<DialogOutOfArea> {
  ShippingPointList shippingPointSelected;
  ShippingPointStoreBloc shippingPointStoreBloc;

  @override
  void initState() {
    super.initState();

    shippingPointSelected = ShippingPointList();
  }

  @override
  void dispose() {
    shippingPointStoreBloc?.close();
    super.dispose();
  }

  void onPressedShippingPoint(ShippingPointList shippingPoint) {
    setState(() {
      shippingPointSelected = shippingPoint;
    });
  }

  void onPressedSelect() {
    Navigator.of(context).pop(shippingPointSelected);
  }

  void onTapSearchMoreHP() {
    Navigator.of(context).pop('SEARCH_MORE');
  }

  void onPressedBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Text('text.out_of_area'.tr(), style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold, color: colorRed1)),
                    Text('text.try_change_address'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('text.branch_near_you'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              buildShippingPointItem(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: InkWell(
                  child: Text('text.search_more_store'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.normal, decoration: TextDecoration.underline, color: colorBlue7)),
                  onTap: () {
                    onTapSearchMoreHP();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Divider(height: 1, thickness: 1),
              ),
              buildFooterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShippingPointItem() {
    return BlocBuilder<ShippingPointStoreBloc, ShippingPointStoreState>(
      builder: (context, state) {
        if (state is SuccessSearchShippingPointStoreState) {
          List<ShippingPointList> lstShippingPointStore = state.lstShippingPointStore;
          if (lstShippingPointStore == null || lstShippingPointStore.length == 0) {
            return Container();
          }

          return StaggeredGridView.count(
            physics: ClampingScrollPhysics(),
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: lstShippingPointStore
                .getRange(0, lstShippingPointStore.length >= 4 ? 4 : lstShippingPointStore.length)
                .map((e) => ShippingPointStoreItem(
                      shippingPointStore: e,
                      isSelected: shippingPointSelected == e,
                      onPressedShippingPoint: onPressedShippingPoint,
                    ))
                .toList(),
            staggeredTiles: lstShippingPointStore.getRange(0, lstShippingPointStore.length >= 4 ? 4 : lstShippingPointStore.length).map((e) => StaggeredTile.fit(2)).toList(),
          );
        }

        return Container();
      },
    );
  }

  Widget buildFooterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
              child: Text('text.back_to_choose_new_address'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
              onPressed: () {
                onPressedBack();
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
              child: Text('text.pick_up_at_store'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
              onPressed: shippingPointSelected?.shippingPointId != null ? () => onPressedSelect() : null,
            ),
          ),
        ],
      ),
    );
  }
}
