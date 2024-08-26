class SlicPOModel {
  ListOfPO? listOfPO;

  SlicPOModel({this.listOfPO});

  SlicPOModel.fromJson(Map<String, dynamic> json) {
    listOfPO =
        json['ListOfPO'] != null ? ListOfPO.fromJson(json['ListOfPO']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listOfPO != null) {
      data['ListOfPO'] = listOfPO!.toJson();
    }
    return data;
  }
}

class ListOfPO {
  String? dOCNO;
  String? dOCDT;
  String? sUPPNAME;
  String? hEADSYSID;
  String? sTATUS;

  ListOfPO({
    this.dOCNO,
    this.dOCDT,
    this.sUPPNAME,
    this.hEADSYSID,
    this.sTATUS,
  });

  ListOfPO.fromJson(Map<String, dynamic> json) {
    dOCNO = json['DOC_NO'];
    dOCDT = json['DOC_DT'];
    sUPPNAME = json['SUPP_NAME'];
    hEADSYSID = json['HEAD_SYS_ID'];
    sTATUS = json['STATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DOC_NO'] = dOCNO;
    data['DOC_DT'] = dOCDT;
    data['SUPP_NAME'] = sUPPNAME;
    data['HEAD_SYS_ID'] = hEADSYSID;
    data['STATUS'] = sTATUS;
    return data;
  }
}
