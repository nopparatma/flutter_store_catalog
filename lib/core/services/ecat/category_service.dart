import 'package:flutter_store_catalog/core/models/ecat/authenticate_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/authenticate_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/compare_article_attirbute_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/compare_article_attribute_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_filter_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_category_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_brand_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_category_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_stock_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_user_profile_rq.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_user_profile_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/base_ecat_service.dart';

class CategoryService extends BaseECatService {

  Future<GetCategoryRs> getCategory(GetCategoryRq rq) async {
    return await post(
      '${appConfig.awsApiServerUrl}/api/GetCategoryV2',
      rq.toJson(),
          (data) => GetCategoryRs.fromJson(data),
    );
  }

  Future<GetBrandRs> getBrand(GetBrandRq rq) async {
    return await post(
      '${appConfig.awsApiServerUrl}/api/GetBrand',
      rq.toJson(),
          (data) => GetBrandRs.fromJson(data),
    );
  }

  Future<GetArticleRs> getArticlePaging(GetArticleRq rq) async {
    return await post(
      '${appConfig.awsApiServerUrl}/api/GetArticlePaging',
      rq.toJson(),
          (data) => GetArticleRs.fromJson(data),
    );
  }

  Future<GetArticleRs> getArticleDetail(GetArticleRq rq) async {
    return await post(
      '${appConfig.awsApiServerUrl}/api/GetArticleDetail',
      rq.toJson(),
          (data) => GetArticleRs.fromJson(data),
    );
  }

  Future<GetArticleFilterRs> getArticleFilter(GetArticleRq rq) async {
    return await post(
      '${appConfig.awsApiServerUrl}/api/GetArticleFilterV2',
      rq.toJson(),
          (data) => GetArticleFilterRs.fromJson(data),
    );
  }

  Future<GetBrandCategoryRs> getBrandCategory(GetBrandCategoryRq rq) async {
    return await post(
      '${appConfig.awsApiServerUrl}/api/GetBrandCategory',
      rq.toJson(),
          (data) => GetBrandCategoryRs.fromJson(data),
    );
  }

  Future<GetStockRs> getStock(GetStockRq rq) async {
    return await post(
      '${appConfig.ecatApiServerUrl}/api/Master/GetStock',
      rq.toJson(),
          (data) => GetStockRs.fromJson(data),
    );
  }

  Future<AuthenticateRs> loginV2(AuthenticateRq rq) async {
    return await post(
      '${appConfig.ecatApiServerUrl}/api/Auth/Login_V2',
      rq.toJson(),
          (data) => AuthenticateRs.fromJson(data),
    );
  }

  Future<GetUserProfileRs> getUserProfile(GetUserProfileRq rq) async {
    return await post(
      '${appConfig.ecatApiServerUrl}/api/Auth/GetUserProfile',
      rq.toJson(),
          (data) => GetUserProfileRs.fromJson(data),
    );
  }

  Future<CompareArticleAttributeRs> compareArticleAttribute(CompareArticleAttributeRq rq) async {
    return await post(
      '${appConfig.ecatApiServerUrl}/api/ECatalog/CompareArticleAttribute',
      rq.toJson(),
          (data) => CompareArticleAttributeRs.fromJson(data),
    );
  }

  Future<String> getContent(String url) async {
    return await getBody(url);
  }

  String getBrandBannerUrl(String brandId){
    return '${appConfig.ecatApiServerUrl}/api/Master/GetBrandBanner/$brandId';
  }

  String getImageByKeyUrl(String key){
    return '${appConfig.ecatApiServerUrl}/api/Master/GetImageByKeyId/$key';
  }
}
