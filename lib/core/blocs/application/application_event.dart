part of 'application_bloc.dart';

@immutable
abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();

  @override
  List<Object> get props => [];
}

class ApplicationUpdateStateModelEvent extends ApplicationEvent {
  final AppSession appSession;
  final GetCategoryRs getCategoryRs;
  final GetBrandRs getBrandRs;
  final GetMstBankRs getMstBankRs;
  final GetDsTimeGroupRs getDsTimeGroupRs;
  final Map sysCfgMap;
  final GetCustomerTitlesRs getCustomerTitlesRs;
  final GetMstMbrCardGroupRs getMstDiscountCardGroup;
  final GetRoomCategoryRs getRoomCategoryRs;

  const ApplicationUpdateStateModelEvent({
    this.appSession,
    this.getCategoryRs,
    this.getBrandRs,
    this.getDsTimeGroupRs,
    this.getMstBankRs,
    this.sysCfgMap,
    this.getCustomerTitlesRs,
    this.getMstDiscountCardGroup,
    this.getRoomCategoryRs,
  });

  @override
  List<Object> get props => [appSession];

  @override
  String toString() {
    return 'ApplicationUpdateStateModelEvent{appSession: $appSession}';
  }
}

class ApplicationLoggedOutEvent extends ApplicationEvent {}
