import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_excess_product_rs.dart';
import 'package:flutter_store_catalog/core/services/dotnet/checklist_information_service.dart';
import 'package:meta/meta.dart';

part 'checklist_information_excess_event.dart';

part 'checklist_information_excess_state.dart';

class ChecklistInformationExcessBloc extends Bloc<ChecklistInformationExcessEvent, ChecklistInformationExcessState> {
  final CheckListInformationService serviceCheckListInformation = getIt<CheckListInformationService>();

  @override
  ChecklistInformationExcessState get initialState => InitialChecklistInformationExcessState();

  @override
  Stream<ChecklistInformationExcessState> mapEventToState(ChecklistInformationExcessEvent event) async* {
    if (event is GetExcessProductEvent) {
      yield* mapGetExcessProductEvent(event);
    }
  }

  Stream<ChecklistInformationExcessState> mapGetExcessProductEvent(GetExcessProductEvent event) async* {
    try {
      yield LoadingCheckListInformationExcessState();

      GetExcessProductRq getExcessProductRq = new GetExcessProductRq();
      getExcessProductRq.mch = event.mch;
      getExcessProductRq.insProductGPID = event.insProductGPID;

      GetExcessProductRs getExcessProductRs = await serviceCheckListInformation.getExcessProduct(getExcessProductRq);
      yield SuccessGetExcessProductState(getExcessProductRs: getExcessProductRs);
    } catch (error, stackTrace) {
      yield ErrorCheckListInformationExcessState(error: AppException(error, stackTrace: stackTrace));
    }
  }
}
