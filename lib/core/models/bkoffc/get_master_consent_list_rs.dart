class GetMasterConsentListRs {
  List<ConsentLists> consentLists;
  List<ConsentLists> consentHistoryLists;
  MessageStatusRs messageStatusRs;

  GetMasterConsentListRs({this.consentLists, this.consentHistoryLists, this.messageStatusRs});

  GetMasterConsentListRs.fromJson(Map<String, dynamic> json) {
    if (json['ConsentLists'] != null) {
      consentLists = new List<ConsentLists>();
      json['ConsentLists'].forEach((v) {
        consentLists.add(new ConsentLists.fromJson(v));
      });
    }
    if (json['ConsentHistoryLists'] != null) {
      consentHistoryLists = new List<ConsentLists>();
      json['ConsentHistoryLists'].forEach((v) {
        consentHistoryLists.add(new ConsentLists.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consentLists != null) {
      data['ConsentLists'] = this.consentLists.map((v) => v.toJson()).toList();
    }
    if (this.consentHistoryLists != null) {
      data['ConsentHistoryLists'] = this.consentHistoryLists.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class ConsentLists {
  String consentName;
  String startDate;
  String endDate;
  String appScope;
  String noticeType;
  String refConsentID;
  String consentVersion;
  String content;

  ConsentLists({
    this.consentName,
    this.startDate,
    this.endDate,
    this.appScope,
    this.noticeType,
    this.refConsentID,
    this.consentVersion,
    this.content,
  });

  ConsentLists.fromJson(Map<String, dynamic> json) {
    consentName = json['ConsentName'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    appScope = json['AppScope'];
    noticeType = json['NoticeType'];
    refConsentID = json['RefConsentID'];
    consentVersion = json['ConsentVersion'];
    content = json['Content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ConsentName'] = this.consentName;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['AppScope'] = this.appScope;
    data['NoticeType'] = this.noticeType;
    data['RefConsentID'] = this.refConsentID;
    data['ConsentVersion'] = this.consentVersion;
    data['Content'] = this.content;
    return data;
  }
}

class MessageStatusRs {
  String status;
  String message;

  MessageStatusRs({this.status, this.message});

  MessageStatusRs.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }
}
