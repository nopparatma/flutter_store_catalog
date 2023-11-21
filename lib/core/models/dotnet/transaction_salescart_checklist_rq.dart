class TransactionSalesCartChecklistRq {
  List<CheckListCart> checkListCart;

  TransactionSalesCartChecklistRq({this.checkListCart});

  TransactionSalesCartChecklistRq.fromJson(Map<String, dynamic> json) {
    if (json['CheckListCart'] != null) {
      checkListCart = new List<CheckListCart>();
      json['CheckListCart'].forEach((v) {
        checkListCart.add(new CheckListCart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.checkListCart != null) {
      data['CheckListCart'] =
          this.checkListCart.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckListCart {
  String action;
  int sgTrnItemOid;
  String artcNo;
  String insMappingId;
  String insResidenceId;
  List<PatternCartList> patternList;

  CheckListCart(
      {this.action,
        this.sgTrnItemOid,
        this.artcNo,
        this.insMappingId,
        this.insResidenceId,
        this.patternList});

  CheckListCart.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    sgTrnItemOid = json['SgTrnItemOid'];
    artcNo = json['ArtcNo'];
    insMappingId = json['InsMappingId'];
    insResidenceId = json['InsResidenceId'];
    if (json['PatternList'] != null) {
      patternList = new List<PatternCartList>();
      json['PatternList'].forEach((v) {
        patternList.add(new PatternCartList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Action'] = this.action;
    data['SgTrnItemOid'] = this.sgTrnItemOid;
    data['ArtcNo'] = this.artcNo;
    data['InsMappingId'] = this.insMappingId;
    data['InsResidenceId'] = this.insResidenceId;
    if (this.patternList != null) {
      data['PatternList'] = this.patternList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PatternCartList {
  String insPatternId;
  String insPatternFormat;
  String insPatternArtcId;

  PatternCartList(
      {this.insPatternId, this.insPatternFormat, this.insPatternArtcId});

  PatternCartList.fromJson(Map<String, dynamic> json) {
    insPatternId = json['InsPatternId'];
    insPatternFormat = json['InsPatternFormat'];
    insPatternArtcId = json['InsPatternArtcId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsPatternId'] = this.insPatternId;
    data['InsPatternFormat'] = this.insPatternFormat;
    data['InsPatternArtcId'] = this.insPatternArtcId;
    return data;
  }
}