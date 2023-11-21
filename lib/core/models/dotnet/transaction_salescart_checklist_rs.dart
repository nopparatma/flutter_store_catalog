class TransactionSalesCartChecklistRs {
  List<CheckListCart> checkListCart;
  MessageStatusRs messageStatusRs;

  TransactionSalesCartChecklistRs({this.checkListCart, this.messageStatusRs});

  TransactionSalesCartChecklistRs.fromJson(Map<String, dynamic> json) {
    if (json['CheckListCart'] != null) {
      checkListCart = new List<CheckListCart>();
      json['CheckListCart'].forEach((v) {
        checkListCart.add(new CheckListCart.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null
        ? new MessageStatusRs.fromJson(json['MessageStatusRs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.checkListCart != null) {
      data['CheckListCart'] =
          this.checkListCart.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class CheckListCart {
  String artcNo;
  int sgTrnItemOid;

  CheckListCart({this.artcNo, this.sgTrnItemOid});

  CheckListCart.fromJson(Map<String, dynamic> json) {
    artcNo = json['ArtcNo'];
    sgTrnItemOid = json['SgTrnItemOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArtcNo'] = this.artcNo;
    data['SgTrnItemOid'] = this.sgTrnItemOid;
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