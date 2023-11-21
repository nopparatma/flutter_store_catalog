import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/store_zone.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:easy_localization/easy_localization.dart';

part 'shipping_point_store_event.dart';

part 'shipping_point_store_state.dart';

class ShippingPointStoreBloc extends Bloc<ShippingPointStoreEvent, ShippingPointStoreState> {
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();

  final ApplicationBloc applicationBloc;
  final SalesCartBloc salesCartBloc;

  ShippingPointStoreBloc(this.applicationBloc, this.salesCartBloc);

  @override
  ShippingPointStoreState get initialState => InitialShippingPointStoreState();

  @override
  Stream<ShippingPointStoreState> mapEventToState(ShippingPointStoreEvent event) async* {
    if (event is SearchShippingPointStoreEvent) {
      yield* mapSearchShippingPointStoreEventToState(event);
    } else if (event is FilterShippingPointStoreEvent) {
      yield* mapFilterShippingPointStoreEventToState(event);
    }
  }

  Stream<ShippingPointStoreState> mapSearchShippingPointStoreEventToState(SearchShippingPointStoreEvent event) async* {
    try {
      yield LoadingShippingPointStoreState();

      AppSession appSession = applicationBloc.state.appSession;
      Customer customer = salesCartBloc?.state?.salesCartDto?.salesCart?.customer;

      GetShippingPointStoreRq getShippingPointStoreRq = GetShippingPointStoreRq();
      getShippingPointStoreRq.customerNo = customer?.customerOid?.toString();

      if (customer?.transportData?.tmsLatitude != null && customer?.transportData?.tmsLongtitude != null) {
        getShippingPointStoreRq.latitude = customer?.transportData?.tmsLatitude;
        getShippingPointStoreRq.longitude = customer?.transportData?.tmsLongtitude;
        getShippingPointStoreRq.district = customer?.district;
        getShippingPointStoreRq.subDistrict = customer?.subDistrict;
        getShippingPointStoreRq.province = customer?.province;
      }

      GetShippingPointStoreRs getShippingPointStoreRs = await _saleOrderService.getShippingPointStore(appSession, getShippingPointStoreRq);

      // Add optionsRegion
      List<StoreZone> listStoreZone = []..add(StoreZone(zoneCode: TypeOfStoreZone.ALL, zoneName: 'text.select_all'.tr()));
      List<String> lstGroup = getShippingPointStoreRs?.shippingPointList?.map((e) => e.zoneCode + '|' + e.zoneName)?.toSet()?.toList();
      lstGroup?.forEach((e) {
        String zoneCode = e.split('|')[0];
        String zoneName = e.split('|')[1];
        listStoreZone.add(StoreZone(zoneCode: zoneCode, zoneName: zoneName));
      });

      yield SuccessSearchShippingPointStoreState(lstShippingPointStore: getShippingPointStoreRs?.shippingPointList, listOptionsZone: listStoreZone);
    } catch (error, stackTrace) {
      yield ErrorShippingPointStoreState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<ShippingPointStoreState> mapFilterShippingPointStoreEventToState(FilterShippingPointStoreEvent event) async* {
    try {
      List<ShippingPointList> lstFilter = []..addAll(event.lstMainShippingPointStore);

      if (event.region != TypeOfStoreZone.ALL && !StringUtil.isNullOrEmpty(event.name)) {
        lstFilter = event.lstMainShippingPointStore.where((e) => e.shippingPointName.toLowerCase().contains(event.name.toLowerCase()) && e.zoneCode == event.region)?.toList();
      } else if (event.region != TypeOfStoreZone.ALL) {
        lstFilter = event.lstMainShippingPointStore.where((e) => e.zoneCode == event.region)?.toList();
      } else if (!StringUtil.isNullOrEmpty(event.name)) {
        lstFilter = event.lstMainShippingPointStore.where((e) => e.shippingPointName.toLowerCase().contains(event.name.toLowerCase()))?.toList();
      }

      yield SuccessFilterShippingPointStoreState(lstShippingPointStoreFilter: lstFilter);
    } catch (error, stackTrace) {
      yield ErrorShippingPointStoreState(error: AppException(error, stackTrace: stackTrace));
    }
  }
}
