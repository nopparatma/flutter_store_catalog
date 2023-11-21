class GetMasterConsentListRq {
  String systemName;
  List<String> refConsentID;
  List<HistoryVersion> historyVersion;

  GetMasterConsentListRq({this.systemName, this.refConsentID, this.historyVersion});

  GetMasterConsentListRq.fromJson(Map<String, dynamic> json) {
    systemName = json['SystemName'];
    refConsentID = json['RefConsentID'].cast<String>();
    if (json['HistoryVersion'] != null) {
      historyVersion = new List<HistoryVersion>();
      json['HistoryVersion'].forEach((v) {
        historyVersion.add(new HistoryVersion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SystemName'] = this.systemName;
    data['RefConsentID'] = this.refConsentID;
    if (this.historyVersion != null) {
      data['HistoryVersion'] =
          this.historyVersion.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryVersion {
  String refConsentID;
  String consentVersion;

  HistoryVersion({this.refConsentID, this.consentVersion});

  HistoryVersion.fromJson(Map<String, dynamic> json) {
    refConsentID = json['RefConsentID'];
    consentVersion = json['ConsentVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RefConsentID'] = this.refConsentID;
    data['ConsentVersion'] = this.consentVersion;
    return data;
  }
}

