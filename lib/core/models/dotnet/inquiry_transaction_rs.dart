import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class InquiryTransactionRs extends BaseDotnetWebApiRs {
  String appChannel;
  String referenceId;
  String qrCodeId;
  String qrCodeStatus;
  String qrCodeStatusMesg;
  String cardNetWorkCode;
  String transDate;
  String transactionId;
  String approvalCode;
  String termType;
  String fromBank;
  String fromName;
  String bankRef;
  String traceNum;
  String custPan;
  double transFee;
  String billerId;
  String reference1;
  String reference2;
  String reference3;
  String merchantId;
  String merchantTransRef;
  String terminalId;
  String createSalesRq;
  String paymentMethod;
  String posId;
  String ticketNo;

  InquiryTransactionRs({
    this.appChannel,
    this.referenceId,
    this.qrCodeId,
    this.qrCodeStatus,
    this.qrCodeStatusMesg,
    this.cardNetWorkCode,
    this.transDate,
    this.transactionId,
    this.approvalCode,
    this.termType,
    this.fromBank,
    this.fromName,
    this.bankRef,
    this.traceNum,
    this.custPan,
    this.transFee,
    this.billerId,
    this.reference1,
    this.reference2,
    this.reference3,
    this.merchantId,
    this.merchantTransRef,
    this.terminalId,
    this.createSalesRq,
    this.posId,
    this.ticketNo,
  });

  InquiryTransactionRs.fromJson(Map<String, dynamic> json) {
    appChannel = json['AppChannel'];
    referenceId = json['ReferenceId'];
    qrCodeId = json['QrCodeId'];
    qrCodeStatus = json['QrCodeStatus'];
    qrCodeStatusMesg = json['QrCodeStatusMesg'];
    cardNetWorkCode = json['CardNetWorkCode'];
    transDate = json['TransDate'];
    transactionId = json['TransactionId'];
    approvalCode = json['ApprovalCode'];
    termType = json['TermType'];
    fromBank = json['FromBank'];
    fromName = json['FromName'];
    bankRef = json['BankRef'];
    traceNum = json['TraceNum'];
    custPan = json['CustPan'];
    transFee = json['TransFee'];
    billerId = json['BillerId'];
    reference1 = json['Reference1'];
    reference2 = json['Reference2'];
    reference3 = json['Reference3'];
    merchantId = json['MerchantId'];
    merchantTransRef = json['MerchantTransRef'];
    terminalId = json['TerminalId'];
    createSalesRq = json['CreateSalesRq'];
    paymentMethod = json['PaymentMethod'];
    posId = json['PosId'];
    ticketNo = json['TicketNo'];
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppChannel'] = this.appChannel;
    data['ReferenceId'] = this.referenceId;
    data['QrCodeId'] = this.qrCodeId;
    data['QrCodeStatus'] = this.qrCodeStatus;
    data['QrCodeStatusMesg'] = this.qrCodeStatusMesg;
    data['CardNetWorkCode'] = this.cardNetWorkCode;
    data['TransDate'] = this.transDate;
    data['TransactionId'] = this.transactionId;
    data['ApprovalCode'] = this.approvalCode;
    data['TermType'] = this.termType;
    data['FromBank'] = this.fromBank;
    data['FromName'] = this.fromName;
    data['BankRef'] = this.bankRef;
    data['TraceNum'] = this.traceNum;
    data['CustPan'] = this.custPan;
    data['TransFee'] = this.transFee;
    data['BillerId'] = this.billerId;
    data['Reference1'] = this.reference1;
    data['Reference2'] = this.reference2;
    data['Reference3'] = this.reference3;
    data['MerchantId'] = this.merchantId;
    data['MerchantTransRef'] = this.merchantTransRef;
    data['TerminalId'] = this.terminalId;
    data['CreateSalesRq'] = this.createSalesRq;
    data['PaymentMethod'] = this.paymentMethod;
    data['PosId'] = this.posId;
    data['TicketNo'] = this.ticketNo;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
