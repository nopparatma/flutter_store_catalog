class GetUserProfileRq {
  String tokenId;

  GetUserProfileRq({this.tokenId});

  GetUserProfileRq.fromJson(Map<String, dynamic> json) {
    tokenId = json['TokenId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TokenId'] = this.tokenId;
    return data;
  }
}