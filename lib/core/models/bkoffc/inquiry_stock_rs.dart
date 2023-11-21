import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class InquiryStockRs extends BaseBackOfficeWebApiRs {
  List<SapBatch> sapBatchs;
  List<SapSite> sapSites;

  InquiryStockRs({this.sapBatchs, this.sapSites});

  InquiryStockRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['sapBatchs'] != null) {
      sapBatchs = new List<SapBatch>();
      json['sapBatchs'].forEach((v) {
        sapBatchs.add(new SapBatch.fromJson(v));
      });
    }
    if (json['sapSites'] != null) {
      sapSites = new List<SapSite>();
      json['sapSites'].forEach((v) {
        sapSites.add(new SapSite.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.sapBatchs != null) {
      data['sapBatchs'] = this.sapBatchs.map((v) => v.toJson()).toList();
    }
    if (this.sapSites != null) {
      data['sapSites'] = this.sapSites.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class SapBatch {
  String artcId;
  String batch;
  num batchQty;
  String dc;
  String unit;

  SapBatch({this.artcId, this.batch, this.batchQty, this.dc, this.unit});

  SapBatch.fromJson(Map<String, dynamic> json) {
    artcId = json['artcId'];
    batch = json['batch'];
    batchQty = json['batchQty'];
    dc = json['dc'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artcId'] = this.artcId;
    data['batch'] = this.batch;
    data['batchQty'] = this.batchQty;
    data['dc'] = this.dc;
    data['unit'] = this.unit;
    return data;
  }
}

class SapSite {
  num qtyForSell;
  String storeId;
  String unit;
  num unrestrict;

  SapSite({this.qtyForSell, this.storeId, this.unit, this.unrestrict});

  SapSite.fromJson(Map<String, dynamic> json) {
    qtyForSell = json['qtyForSell'];
    storeId = json['storeId'];
    unit = json['unit'];
    unrestrict = json['unrestrict'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qtyForSell'] = this.qtyForSell;
    data['storeId'] = this.storeId;
    data['unit'] = this.unit;
    data['unrestrict'] = this.unrestrict;
    return data;
  }
}
