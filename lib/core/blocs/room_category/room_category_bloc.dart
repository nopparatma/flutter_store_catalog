import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/master_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';

part 'room_category_event.dart';

part 'room_category_state.dart';

class RoomCategoryBloc extends Bloc<RoomCategoryEvent, RoomCategoryState> {
  final ApplicationBloc applicationBloc;
  final MasterService _eCatMasterService = getIt<MasterService>();

  RoomCategoryBloc(this.applicationBloc);

  @override
  RoomCategoryState get initialState => InitialRoomCategoryState();

  @override
  Stream<RoomCategoryState> mapEventToState(RoomCategoryEvent event) async* {
    if (event is SearchRoomCategoryEvent) {
      yield* mapSearchRoomCategoryEventToState(event);
    } else if (event is FetchRoomCategoryEvent) {
      yield* mapFetchRoomCategoryEventToState(event);
    }
  }

  Stream<RoomCategoryState> mapSearchRoomCategoryEventToState(SearchRoomCategoryEvent event) async* {
    try {
      yield LoadingRoomCategoryState();

      // Filter by roomSeq
      RoomList roomSelected = RoomList();
      if (event.roomSeq != null && applicationBloc?.state?.getRoomCategoryRs?.roomList != null && applicationBloc.state.getRoomCategoryRs.roomList.length > 0) {
        for (num i = 0; i < applicationBloc.state.getRoomCategoryRs.roomList.length; i++) {
          RoomList roomItem = applicationBloc.state.getRoomCategoryRs.roomList[i];
          if (event.roomSeq == roomItem.roomSeq) {
            roomSelected = roomItem;
            break;
          }
        }
      }

      yield SearchRoomCategorySuccessState(roomSelected: roomSelected);
    } catch (error, stackTrace) {
      yield ErrorRoomCategoryState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<RoomCategoryState> mapFetchRoomCategoryEventToState(FetchRoomCategoryEvent event) async* {
    try {
      yield LoadingRoomCategoryState();

      if (applicationBloc?.state?.getRoomCategoryRs == null) {
        GetRoomCategoryRs getRoomCategoryRs = await _eCatMasterService.getRoomCategory(GetRoomCategoryRq());

        // Remove null MCH1
        getRoomCategoryRs.roomList?.forEach((e) {
          e.mch2List?.forEach((mch2) {
            mch2.mCH1CategoryList?.removeWhere((mch1) => !mch1.searchTermList.any((searchTerm) => StringUtil.isNotEmpty(searchTerm.mCHId)));
          });
        });

        // Remove null MCH2
        getRoomCategoryRs.roomList?.forEach((e) {
          e.mch2List?.removeWhere((mch2) => mch2.mCH1CategoryList == null || mch2.mCH1CategoryList.isEmpty);
        });

        applicationBloc.add(
          ApplicationUpdateStateModelEvent(getRoomCategoryRs: getRoomCategoryRs),
        );
      }

      yield FetchRoomCategorySuccessState();
    } catch (error, stackTrace) {
      yield ErrorRoomCategoryState(AppException(error, stackTrace: stackTrace));
    }
  }
}
