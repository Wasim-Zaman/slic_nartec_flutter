class TransactionCodeModel {
  ListOfTransactionCod? listOfTransactionCod;

  TransactionCodeModel({this.listOfTransactionCod});

  TransactionCodeModel.fromJson(Map<String, dynamic> json) {
    listOfTransactionCod = json['ListOfTransactionCod'] != null
        ? ListOfTransactionCod.fromJson(json['ListOfTransactionCod'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listOfTransactionCod != null) {
      data['ListOfTransactionCod'] = listOfTransactionCod!.toJson();
    }
    return data;
  }
}

class ListOfTransactionCod {
  String? tXNCODE;
  String? tXNNAME;

  ListOfTransactionCod({this.tXNCODE, this.tXNNAME});

  ListOfTransactionCod.fromJson(Map<String, dynamic> json) {
    tXNCODE = json['TXN_CODE'];
    tXNNAME = json['TXN_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TXN_CODE'] = tXNCODE;
    data['TXN_NAME'] = tXNNAME;
    return data;
  }
}
