enum DateStatus {
  Available,
  Unavailable,
  OutOfRange,
}

enum CancelSalesType {
  SalesCart,
  SalesOrder,
}

class SystemConfig {
  static const String TABLET_POS_NO = "tablet.pos.no";
  static const String ART_DELIVERY_FEE = "art.delivey_fee"; //ไม่ได้พิมพ์ผิด
  static const String CENSOR_PHONE_NO = "censor.phone.no";
  static const String CENSOR_ID_CARD = "censor.id.card";
  static const String POLICY_DATA_TH_EN = "policy.data.th.en";
  static const String DS_SERVICE_AREA_NOT_FOUND = "ds.service.area.not.found";
  static const String HIRE_PURCHASE_DISCOUNT_CONDITION_TYPE = "hire.purchase.discount.condition.type";
}

class SystemName {
  static const String SCAT = 'scat';
}

class SellChannel {
  static const String SALES_CHANNEL = 'ECATALOGUE';
}

class TypeOfCustomerSearch {
  static const String ALL = '0';
  static const String TELEPHONE = '1';
  static const String CUSTNO = '2';
  static const String MEMBERNO = '3';
  static const String FULLNAME = '4';
  static const String IDCARD = '5';
}

class CustomerPartnerType {
  static const String SOLD_TO = "AG";
  static const String SHIP_TO = "WE";
  static const String BILL_TO = "RE";
  static const String PAYER = "RG";
}

class TimeNo {
  static const String MORNING = '10';
  static const String AFTERNOON = '20';
  static const String EVENING = '30';
  static const String NIGHT = '40';
  static const String SPECIAL = '50';
  static const String NO_DURATION = '0';
}

class TimeType {
  static const String NO_DURATION = '01';
  static const String SPECIFY_DURATION = '02';
}

class SOMode {
  static const String STORE_DELIVERY = 'STORE_DELIVERY';
  static const String DELIVERY = 'DELIVERY';
  static const String CUST_RECEIVE = 'CUST_RECEIVE';
  static const String STORE_MANUAL = 'STORE_MANUAL';
  static const String INSTALL = 'INSTALL';
}

class Shippoint {
  static const String VENDOR = 'V001';
  static const String CUSTOMER = 'C001';
  static const String DC01 = 'DC01';
}

class JobType {
  static const String D = 'D';
  static const String I = 'I';
  static const String CN = 'CN';
}

class ConfType {
  static const String SMS = '05';
}

class WorkerStatus {
  static const String AVAILABLE = 'Y';
  static const String NOT_AVAILABLE = 'N';
  static const String OFF = 'O';
}

class QueueStyle {
  static const String SAME_DAY = 'S';
  static const String NORMAL = 'N';
  static const String NEXT_DAY = 'X';
}

class InquiryReserve {
  static const int INQUIRY_DAY = 15;
}

class MasterDataStatus {
  static const String LOAD = 'L';
  static const String NOT_LOAD = 'NL';
}

class TypeOfAddress {
  static const String SUBDISTRICT = '1';
  static const String DISTRICT = '2';
  static const String PROVINCE = '3';
  static const String ZIPCODE = '4';
  static const String VILLAGE = '5';
  static const String ADDRESS = '6';
}

class AddressFormat {
  static const String THAI = "01";
  static const String ENG = "02";
  static const String NO_FORMAT = "03";
}

class SearchAddress {
  static const String ZIPCODE = "ZIPCODE";
  static const String PROVINCE = "PROVINCE";
  static const String DISTRICT = "DISTRICT";
  static const String SUB_DISTRICT = "SUBDISTRICT";
  static const String START_ROW = "0";
  static const String PAGE_SIZE = "30";
}

class TypeOfBillTo {
  static const String GENERAL_PERSON = 'GENERAL_PERSON';
  static const String NITI_PERSON = 'NITI_PERSON';
  static const String CITIZEN_CARD = '1';
  static const String PASSPORT_CARD = '2';
  static const String SPECIFIED = '1';
  static const String NOT_SPECIFIED = '3';
  static const String HEAD_OFFICE = 'H';
  static const String STORE = 'S';
  static const String OTHER = 'O';
}

class ComponentType {
  static const String TEXTBOX = 'TEXTBOX';
  static const String RADIOBUTTON = 'RADIOBUTTON';
  static const String LABEL = 'LABEL';
}

class PatType {
  static const String COURIER = 'CR';
  static const String HOMEPRO = 'HP';
}

class DsConfType {
  static const String TEL = '04';
  static const String SMS = '05';
  static const String NOT_CONFIRM = '07';
}

class CalPromotionCAAppId {
  static const String SCAT_POS = 'SCAT_POS';
  static const String SCAT_ONLINE = 'SCAT_ONLINE';
}

class CreateCustomerMode {
  static const String SOLD_TO = 'SOLD_TO';
  static const String SHIP_TO = 'SHIP_TO';
  static const String BILL_TO = 'BILL_TO';
}

class GetMasterVillageCondo {
  static const num START_ROW = 0;
  static const num PAGE_SIZE = 30;
}

class Knowledge {
  static const int COUNT_INIT_KNOWLEDGE_VIEW = 6;
}

class CrCardGroup {
  static const String CREDIT = 'CRDC';
  static const String QR = 'QRCD';
  static const String OTHER = 'OTHR';
}

class CardNetwork {
  static const String QRPP = '01';
  static const String VISA = '03';
  static const String MC = '04';
  static const String UPAC = '05';
}

class TenderIdOfCardNetwork {
  static const String QRPP = 'QRPP';
  static const String VISA = 'VISA';
  static const String MC = 'MC';
  static const String UPAC = 'UPAC';
  static const String HPCD = 'HPCD';
  static const String DISCOUNT_HPVS = 'HPVS';
}

class TenderIdCash {
  static const String CASH = 'CASH';
}

class QRPaymentType {
  static const String PROMPT_PAY = '1';
  static const String CREDIT = '2';
  static const String HOMEPRO_VISA = '3';
  static const String PAYMENT_GATEWAY = '4';
}

class QRPayment {
  static const String APP_CHANNEL = 'SS';
  static const String BBL_CONFIG_01 = '01';
  static const String BBL_CONFIG_02 = '02';
  static const String BBL_CONFIG_05 = '05';
  static const String SUCCESSFUL_PAYMENT = '000';
  static const num INQUIRY_TIME_REFRESH = 2000;
}

class QRCodeStatus {
  static const String BBL_APPROVE = '000';
  static const String KSRI_APPROVE = 'APPROVED';
  static const String KSRI_SETTLE = 'SETTLE';
}

class PromotionArticleTypeId {
  static const String GIFT = '201';
  static const String SERVICE_1 = '203';
  static const String SERVICE_2 = '204';
}

class HirePurchaseLevel {
  static const String ART = "ART";
  static const String MCH = "MCH";
  static const String AIT = "AIT";
}

class TypeOfStoreZone {
  static const String ALL = 'ALL';
  static const String EAST = 'E';
  static const String SOUTH = 'S';
  static const String NORTH = 'N';
  static const String WEST = 'W';
  static const String NORTH_EAST = 'NE';
  static const String CENTRAL = 'C';
  static const String BKK = 'BKK';
}

class Policy {
  static const String SYSTEM_NAME = 'SCAT';
  static const String THAI = 'TH';
  static const String ENGLISH = 'EN';
}

class Language {
  static const String THAI = 'th-TH';
  static const String ENGLISH = 'en-US';
}

class MasterTabDelivery {
  static const String QDELIVERY = "DELIVERY";
  static const String QINSTALL = "INSTALL";
  static const String SO_CHANNEL_CODE_TABLET = "tablet";
  static const String GIS_DATA = "GIS_DATA";
}

class OrderStepBackFlag {
  static const String CUSTOMER_RECEIVE = "CUSTOMER_RECEIVE";
  static const String CHANGE_CUSTOMER = "CHANGE_CUSTOMER";
  static const String CREATE_SHIP_TO = "CREATE_SHIP_TO";
  static const String INQUIRY_SAME_DAY_SINGLE_DAY = "INQUIRY_SAME_DAY_SINGLE_DAY";
  static const String EDIT_DELIVERY_DATE = "EDIT_DELIVERY_DATE";
}

class ShippingPointConstants {
  static const String DS_CODE_LIST = 'DC01,DC02';
}

class CustomerTaxId {
  static const String DEFAULT_TAX_ID = '0000000000000';
}

class RegularExpression {
  static const String EMAIL_FORMAT = r"^[a-zA-Z0-9.a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String EMAIL = r"^[a-zA-Z0-9@._-]+";
  static const String CHARACTER = r"[a-zA-Zก-๙0-9]+";
  static const String CHARACTER_WITH_SPACE = r"[a-zA-Zก-๙0-9\s]+";
}
