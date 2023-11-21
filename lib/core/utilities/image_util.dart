import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';

class ImageUtil {
  static String getFullURL(String url) {
    if (StringUtil.isNullOrEmpty(url)) return '';
    return getFullURLProxy(url);
    // return url;
  }

  static String getFullURLProxy(String url) {
    if (StringUtil.isNullOrEmpty(url)) return '';
    var appConfig = AppConfig.instance;
    return '${appConfig.ecatApiServerUrl}/api/ECatalog/Forward?useProxy=Y&url=$url';
  }

  static String getFullURLInternal(String url) {
    if (StringUtil.isNullOrEmpty(url)) return '';
    var appConfig = AppConfig.instance;
    return '${appConfig.ecatApiServerUrl}/api/ECatalog/Forward?url=$url';
  }
}