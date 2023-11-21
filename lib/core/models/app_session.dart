import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:string_validator/string_validator.dart';

import 'user_profile.dart';
import '../utilities/string_util.dart';

class AppSession {
  UserProfile _userProfile;
  DateTime _lastActionTime;
  String ssApiServerUrl;
  DateTime _transactionDateTime;

  UserProfile get userProfile => _userProfile;

  set userProfile(UserProfile value) {
    _userProfile = value;
    _setUserProfileSsApiServerUrl();
  }

  DateTime get lastActionTime => _lastActionTime;

  set lastActionTime(DateTime value) {
    _lastActionTime = value;
  }

  void _setUserProfileSsApiServerUrl() {
    if (_userProfile != null && !StringUtil.isNullOrEmpty(_userProfile.storeIP)) {
      if (isIP(_userProfile.storeIP)) {
        ssApiServerUrl = Uri(
          scheme: 'http',
          host: _userProfile.storeIP,
          port: 9081,
        ).toString();
      } else {
        ssApiServerUrl = Uri(
          scheme: 'http',
          host: _userProfile.storeIP,
        ).toString();
      }
    }
  }

  DateTime get transactionDateTime => _transactionDateTime;

  set transactionDateTime(DateTime value) {
    _transactionDateTime = value;
  }

  @override
  String toString() {
    return 'AppSession{_userProfile: $_userProfile, _lastActionTime: $_lastActionTime, ssApiServerUrl: $ssApiServerUrl, _transactionDateTime: $_transactionDateTime}';
  }

  AppSession() {}

  AppSession.fromJson(Map<String, dynamic> json) {
    _userProfile = UserProfile.fromJson(json['userProfile']);
    transactionDateTime = DateTimeUtil.toDateTime(json['transactionDateTime']);
    ssApiServerUrl = json['ssApiServerUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._userProfile != null) {
      data['userProfile'] = this._userProfile.toJson();
    }
    data['transactionDateTime'] = this.transactionDateTime?.toIso8601String();
    data['ssApiServerUrl'] = this.ssApiServerUrl;
    return data;
  }
}
