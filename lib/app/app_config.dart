import 'package:flutter/material.dart';

enum FlavorEnvironment {
  dev,
  qas,
  trn,
  prd,
}

enum FlavorCompany {
  homepro,
  megahome,
  homepromy,
}

const String bkoffcContextApi = 'ECCBackOfficeWebAPI/api';
const String salesPrmtnContextApi = 'SalesPromotionWebAPI/api';

class AppConfig {
  final FlavorEnvironment flavorEnvironment;
  final FlavorCompany flavorCompany;
  final String applicationName;
  final String ecatApiServerUrl;
  final String awsApiServerUrl;
  final String salesGuideApiServerUrl;
  final String ssonApiServerUrl;
  final String commonApiServerUrl;
  final String qrPaymentApiServerUrl;
  final String pdpaApiServerUrl;
  final String clmApiServerUrl;
  final String custApiServerUrl;
  final String labelApiServerUrl;
  final int sessionTimeoutSec;
  final int qrPaymentTimeoutMin;

  static AppConfig _instance;

  factory AppConfig({
    @required FlavorEnvironment flavorEnvironment,
    @required FlavorCompany flavorCompany,
    @required String applicationName,
    @required String ecatApiServerUrl,
    @required String awsApiServerUrl,
    @required String salesGuideApiServerUrl,
    @required String ssonApiServerUrl,
    @required String commonApiServerUrl,
    @required String qrPaymentApiServerUrl,
    @required String pdpaApiServerUrl,
    @required String clmApiServerUrl,
    @required String custApiServerUrl,
    @required String labelApiServerUrl,
    @required int sessionTimeoutSec,
    @required int qrPaymentTimeoutMin,
  }) {
    _instance ??= AppConfig._internal(
      flavorEnvironment,
      flavorCompany,
      applicationName,
      ecatApiServerUrl,
      awsApiServerUrl,
      salesGuideApiServerUrl,
      ssonApiServerUrl,
      commonApiServerUrl,
      qrPaymentApiServerUrl,
      pdpaApiServerUrl,
      clmApiServerUrl,
      custApiServerUrl,
      labelApiServerUrl,
      sessionTimeoutSec,
      qrPaymentTimeoutMin,
    );
    return _instance;
  }

  AppConfig._internal(
    this.flavorEnvironment,
    this.flavorCompany,
    this.applicationName,
    this.ecatApiServerUrl,
    this.awsApiServerUrl,
    this.salesGuideApiServerUrl,
    this.ssonApiServerUrl,
    this.commonApiServerUrl,
    this.qrPaymentApiServerUrl,
    this.pdpaApiServerUrl,
    this.clmApiServerUrl,
    this.custApiServerUrl,
    this.labelApiServerUrl,
    this.sessionTimeoutSec,
    this.qrPaymentTimeoutMin,
  );

  static AppConfig get instance {
    return _instance;
  }

  static bool isDevelopment() => _instance.flavorEnvironment == FlavorEnvironment.dev;

  static bool isQAS() => _instance.flavorEnvironment == FlavorEnvironment.qas;

  static bool isTraining() => _instance.flavorEnvironment == FlavorEnvironment.trn;

  static bool isProduction() => _instance.flavorEnvironment == FlavorEnvironment.prd;

  static bool isHomePro() => _instance.flavorCompany == FlavorCompany.homepro;

  static bool isMegaHome() => _instance.flavorCompany == FlavorCompany.megahome;

  static bool isHomeProMalaysia() => _instance.flavorCompany == FlavorCompany.homepromy;

  // Environment Flavor Config
  static AppConfig dev() {
    return AppConfig(
      flavorEnvironment: FlavorEnvironment.dev,
      flavorCompany: FlavorCompany.homepro,
      applicationName: 'Store Catalog DEV',
      ecatApiServerUrl: 'http://qas-ecatsvcwebapi.homepro.local',
      awsApiServerUrl: 'https://qas-hscaws-apihp.homepro.co.th',
      salesGuideApiServerUrl: 'http://qas-salesguidewebapi.homepro.local',
      ssonApiServerUrl: 'http://qas-ssonsvcwebapi.homepro.local',
      commonApiServerUrl: 'http://qas-commsvcwebapi.homepro.local',
      qrPaymentApiServerUrl: 'http://qas-qrpaymentwebapi.homepro.local',
      pdpaApiServerUrl: 'http://qas-pdpasvcwebapi.homepro.local',
      clmApiServerUrl: 'http://qas-clmsvcwebapi.homepro.local',
      custApiServerUrl: 'http://qas-custsvcwebapi.homepro.local',
      labelApiServerUrl: 'http://qas-labelsvcwebapi.homepro.local',
      sessionTimeoutSec: 180,
      qrPaymentTimeoutMin: 2,
    );
  }

  static AppConfig qas_homepro() {
    return AppConfig(
      flavorEnvironment: FlavorEnvironment.qas,
      flavorCompany: FlavorCompany.homepro,
      applicationName: 'Store Catalog QAS',
      ecatApiServerUrl: 'http://qas-ecatsvcwebapi.homepro.local',
      awsApiServerUrl: 'https://qas-hscaws-apihp.homepro.co.th',
      salesGuideApiServerUrl: 'http://qas-salesguidewebapi.homepro.local',
      ssonApiServerUrl: 'http://qas-ssonsvcwebapi.homepro.local',
      commonApiServerUrl: 'http://qas-commsvcwebapi.homepro.local',
      qrPaymentApiServerUrl: 'http://qas-qrpaymentwebapi.homepro.local',
      pdpaApiServerUrl: 'http://qas-pdpasvcwebapi.homepro.local',
      clmApiServerUrl: 'http://qas-clmsvcwebapi.homepro.local',
      custApiServerUrl: 'http://qas-custsvcwebapi.homepro.local',
      labelApiServerUrl: 'http://qas-labelsvcwebapi.homepro.local',
      sessionTimeoutSec: 180,
      qrPaymentTimeoutMin: 2,
    );
  }

  static AppConfig prd_homepro() {
    return AppConfig(
      flavorEnvironment: FlavorEnvironment.prd,
      flavorCompany: FlavorCompany.homepro,
      applicationName: 'Store Catalog',
      ecatApiServerUrl: 'http://ecatsvcwebapi.homepro.local',
      awsApiServerUrl: 'https://hscaws-apihp.homepro.co.th',
      salesGuideApiServerUrl: 'http://salesguidewebapi.homepro.local',
      ssonApiServerUrl: 'http://ssonsvcwebapi.homepro.local',
      commonApiServerUrl: 'http://commsvcwebapi.homepro.local',
      qrPaymentApiServerUrl: 'http://qrpaymentwebapi.homepro.local',
      pdpaApiServerUrl: 'http://pdpasvcwebapi.homepro.local',
      clmApiServerUrl: 'http://clmsvcwebapi.homepro.local',
      custApiServerUrl: 'http://custsvcwebapi.homepro.local',
      labelApiServerUrl: 'http://labelsvcwebapi.homepro.local',
      sessionTimeoutSec: 180,
      qrPaymentTimeoutMin: 2,
    );
  }
}
