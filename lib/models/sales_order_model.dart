class SalesOrderModel {
  ListOfSO? listOfSO;

  SalesOrderModel({this.listOfSO});

  SalesOrderModel.fromJson(Map<String, dynamic> json) {
    listOfSO =
        json['ListOfSO'] != null ? ListOfSO.fromJson(json['ListOfSO']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listOfSO != null) {
      data['ListOfSO'] = listOfSO!.toJson();
    }
    return data;
  }
}

class ListOfSO {
  String? sONUMBER;
  String? sOCUSTNAME;
  String? sOLOCNCODE;
  String? dELLOCN;
  String? sTATUS;
  int? hEADSYSID;

  ListOfSO(
      {this.sONUMBER,
      this.sOCUSTNAME,
      this.sOLOCNCODE,
      this.dELLOCN,
      this.sTATUS,
      this.hEADSYSID});

  ListOfSO.fromJson(Map<String, dynamic> json) {
    sONUMBER = json['SO_NUMBER'];
    sOCUSTNAME = json['SO_CUST_NAME'];
    sOLOCNCODE = json['SO_LOCN_CODE'];
    dELLOCN = json['DEL_LOCN'];
    sTATUS = json['STATUS'];
    hEADSYSID = json['HEAD_SYS_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SO_NUMBER'] = sONUMBER;
    data['SO_CUST_NAME'] = sOCUSTNAME;
    data['SO_LOCN_CODE'] = sOLOCNCODE;
    data['DEL_LOCN'] = dELLOCN;
    data['STATUS'] = sTATUS;
    data['HEAD_SYS_ID'] = hEADSYSID;
    return data;
  }
}
