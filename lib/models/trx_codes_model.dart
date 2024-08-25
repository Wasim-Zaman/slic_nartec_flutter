class TrxCodesModel {
  String? tXNCODE;
  String? tXNNAME;
  String? tXNTYPE;
  String? tXNLOCATIONCODE;

  TrxCodesModel(
      {this.tXNCODE, this.tXNNAME, this.tXNTYPE, this.tXNLOCATIONCODE});

  TrxCodesModel.fromJson(Map<String, dynamic> json) {
    tXNCODE = json['TXN_CODE'];
    tXNNAME = json['TXN_NAME'];
    tXNTYPE = json['TXN_TYPE'];
    tXNLOCATIONCODE = json['TXNLOCATIONCODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TXN_CODE'] = tXNCODE;
    data['TXN_NAME'] = tXNNAME;
    data['TXN_TYPE'] = tXNTYPE;
    data['TXNLOCATIONCODE'] = tXNLOCATIONCODE;
    return data;
  }
}
