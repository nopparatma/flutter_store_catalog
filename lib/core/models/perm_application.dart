class PermApplication {
  String appNo;
  String functionNo;
  String appName;
  String imageUrl;
  String downloadUrl;
  String appLinkIosUrl;
  String appLinkAndroidUrl;

  PermApplication({
    this.appNo,
    this.functionNo,
    this.appName,
    this.imageUrl,
    this.downloadUrl,
    this.appLinkIosUrl,
    this.appLinkAndroidUrl,
  });

  PermApplication.fromJson(Map<String, dynamic> json) {
    appNo = json['appNo'];
    functionNo = json['functionNo'];
    appName = json['appName'];
    imageUrl = json['imageUrl'];
    downloadUrl = json['downloadUrl'];
    appLinkIosUrl = json['appLinkIosUrl'];
    appLinkAndroidUrl = json['appLinkAndroidUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appNo'] = this.appNo;
    data['functionNo'] = this.functionNo;
    data['appName'] = this.appName;
    data['imageUrl'] = this.imageUrl;
    data['downloadUrl'] = this.downloadUrl;
    data['appLinkIosUrl'] = this.appLinkIosUrl;
    data['appLinkAndroidUrl'] = this.appLinkAndroidUrl;
    return data;
  }
}
