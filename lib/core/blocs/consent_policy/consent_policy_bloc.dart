import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_consent_list_rs.dart';
import 'package:flutter_store_catalog/core/services/dotnet/privacy_policy_service.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:meta/meta.dart';

part 'consent_policy_event.dart';

part 'consent_policy_state.dart';

class ConsentPolicyBloc extends Bloc<ConsentPolicyEvent, ConsentPolicyState> {
  final PrivacyPolicyService _privacyService = getIt<PrivacyPolicyService>();

  final ApplicationBloc applicationBloc;

  ConsentPolicyBloc(this.applicationBloc);

  @override
  ConsentPolicyState get initialState => InitialConsentPolicyState();

  @override
  Stream<ConsentPolicyState> mapEventToState(ConsentPolicyEvent event) async* {
    if (event is LoadConsentPolicyEvemt) {
      yield* mapLoadConsentPolicyEvemtToState(event);
    }
  }

  Stream<ConsentPolicyState> mapLoadConsentPolicyEvemtToState(LoadConsentPolicyEvemt event) async* {
    try {
      yield LoadingConsentPolicyState();

      Map<String, List<ConsentLists>> policyData = Map<String, List<ConsentLists>>();

      String policyThEn = applicationBloc.state.sysCfgMap[SystemConfig.POLICY_DATA_TH_EN];
      List<String> lstPolicy = [];
      List<String> lstPolicyThEn = policyThEn != null ? policyThEn.split(',') : [];

      if (lstPolicyThEn != null && lstPolicyThEn.length > 0) {
        lstPolicyThEn.forEach((policy) {
          lstPolicy.add(policy);
        });
      }

      if (lstPolicy.isEmpty) {
        yield initialState;
        return;
      }

      var futureTHGetMasterConsentListRs = getMasterConsentList(lstPolicy, Language.THAI);
      var futureENGetMasterConsentListRs = getMasterConsentList(lstPolicy, Language.ENGLISH);

      // parallel
      await Future.wait([
        futureTHGetMasterConsentListRs,
        futureENGetMasterConsentListRs,
      ], eagerError: true);

      GetMasterConsentListRs getTHMasterConsentListRs = await futureTHGetMasterConsentListRs;
      GetMasterConsentListRs getENMasterConsentListRs = await futureENGetMasterConsentListRs;

      // Get THAI Content
      getTHMasterConsentListRs.consentLists?.sort((a, b) {
        return a.refConsentID.compareTo(b.refConsentID);
      });
      policyData.putIfAbsent(Policy.THAI, () => getTHMasterConsentListRs.consentLists ?? []);

      // Get ENG Content
      getENMasterConsentListRs.consentLists?.sort((a, b) {
        return a.refConsentID.compareTo(b.refConsentID);
      });
      policyData.putIfAbsent(Policy.ENGLISH, () => getENMasterConsentListRs.consentLists ?? []);

      yield SuccessConsentPolicyState(policyData);
    } catch (error, stackTrace) {
      yield ErrorConsentPolicyState(AppException(error, stackTrace: stackTrace));
    }
  }

  Future<GetMasterConsentListRs> getMasterConsentList(List<String> lstPolicy, String language) async {
    GetMasterConsentListRq rq = GetMasterConsentListRq();
    rq.systemName = Policy.SYSTEM_NAME;
    rq.refConsentID = lstPolicy;

    return await _privacyService.getMasterConsentList(rq, language);
  }
}
