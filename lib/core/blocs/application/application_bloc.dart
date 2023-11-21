import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_customer_titles_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_ds_time_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rs.dart';
import 'package:flutter_store_catalog/core/models/dto/menu_dto.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'application_event.dart';

part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  @override
  ApplicationState get initialState => ApplicationState();

  @override
  Stream<ApplicationState> mapEventToState(ApplicationEvent event) async* {
    if (event is ApplicationUpdateStateModelEvent) {
      yield ApplicationState(
        appSession: event.appSession ?? state.appSession,
        getBrandRs: event.getBrandRs ?? state.getBrandRs,
        getCategoryRs: event.getCategoryRs ?? state.getCategoryRs,
        getMstBankRs: event.getMstBankRs ?? state.getMstBankRs,
        getDsTimeGroupRs: event.getDsTimeGroupRs ?? state.getDsTimeGroupRs,
        sysCfgMap: event.sysCfgMap ?? state.sysCfgMap,
        getCustomerTitlesRs: event.getCustomerTitlesRs ?? state.getCustomerTitlesRs,
        getMstDiscountCardGroup: event.getMstDiscountCardGroup ?? state.getMstDiscountCardGroup,
        getRoomCategoryRs: event.getRoomCategoryRs ?? state.getRoomCategoryRs,
      );
    } else if (event is ApplicationLoggedOutEvent) {
      yield ApplicationState(
        appSession: null,
      );
    }
  }
}
