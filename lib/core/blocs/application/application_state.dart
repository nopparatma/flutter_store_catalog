part of 'application_bloc.dart';

class ApplicationState extends Equatable {
  final AppSession appSession;
  final GetCategoryRs getCategoryRs;
  final GetBrandRs getBrandRs;
  final GetMstBankRs getMstBankRs;
  final GetDsTimeGroupRs getDsTimeGroupRs;
  final Map sysCfgMap;
  final GetCustomerTitlesRs getCustomerTitlesRs;
  final GetMstMbrCardGroupRs getMstDiscountCardGroup;
  final GetRoomCategoryRs getRoomCategoryRs;

  const ApplicationState({
    this.appSession,
    this.getCategoryRs,
    this.getBrandRs,
    this.getMstBankRs,
    this.getDsTimeGroupRs,
    this.sysCfgMap,
    this.getCustomerTitlesRs,
    this.getMstDiscountCardGroup,
    this.getRoomCategoryRs,
  });

  @override
  List<Object> get props => [appSession, getBrandRs, getCategoryRs, getRoomCategoryRs];

  bool isAuthenticated() {
    return appSession != null && appSession.userProfile != null;
  }

  String getCensorPhoneNo(String phoneNo) {
    return StringUtil.getCensorText(phoneNo, sysCfgMap[SystemConfig.CENSOR_PHONE_NO]);
  }

  String getCensorIdCard(String idCard) {
    return StringUtil.getCensorText(idCard, sysCfgMap[SystemConfig.CENSOR_ID_CARD]);
  }
}
