class GetProductKnowledgeRq {
  String mch;
  List<String> knowledgeIdList;

  GetProductKnowledgeRq({this.mch, this.knowledgeIdList});

  GetProductKnowledgeRq.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    knowledgeIdList = json['KnowledgeIdList']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    data['KnowledgeIdList'] = this.knowledgeIdList;
    return data;
  }
}
