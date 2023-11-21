

import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/utilities/shared_pref_util.dart';

class AppSessionUtil {

  static const String SHARED_PREF_APP_SESSION = 'SHARED_PREF_APP_SESSION';

  static save(AppSession appSession) async {
    await SharedPrefUtil.save(SHARED_PREF_APP_SESSION, appSession.toJson());
  }

  static Future<void> remove() async {
    await SharedPrefUtil.remove(SHARED_PREF_APP_SESSION);
  }

  static Future<AppSession> get() async {
    AppSession localObj;
    try {
      localObj = AppSession.fromJson(await SharedPrefUtil.read(SHARED_PREF_APP_SESSION));
    } catch (error) {
      print('error load shared pref : $error');
    }
    return localObj;
  }

  static Future<bool> isLoggedIn() async {
    AppSession localObj;
    try {
      localObj = AppSession.fromJson(await SharedPrefUtil.read(SHARED_PREF_APP_SESSION));
    } catch (error) {
      print('error load shared pref : $error');
    }
    return localObj != null;
  }
}