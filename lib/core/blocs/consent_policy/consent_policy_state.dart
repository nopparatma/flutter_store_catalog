part of 'consent_policy_bloc.dart';

@immutable
abstract class ConsentPolicyState {}

class InitialConsentPolicyState extends ConsentPolicyState {}

class LoadingConsentPolicyState extends ConsentPolicyState {}

class ErrorConsentPolicyState extends ConsentPolicyState {
  final dynamic error;

  ErrorConsentPolicyState(this.error);
}

class SuccessConsentPolicyState extends ConsentPolicyState {
  final Map<String, List<ConsentLists>> policyData;

  SuccessConsentPolicyState(this.policyData);

  List<ConsentLists> getListPolicyByLanguage(BuildContext context) {
    String language = LanguageUtil.isTh(context) ? Policy.THAI : Policy.ENGLISH;
    if (policyData[language] == null) return [];
    return policyData[language];
  }
}