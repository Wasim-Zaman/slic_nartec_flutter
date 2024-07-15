class LineItem {
  int? hEADSYSID;
  String? iTEMCODE;
  String? iTEMNAME;
  String? gRADE;
  String? uOM;
  int? pOQTY;
  String? rECEIVEDQTY;
  int? iTEMSYSID;

  LineItem(
      {this.hEADSYSID,
      this.iTEMCODE,
      this.iTEMNAME,
      this.gRADE,
      this.uOM,
      this.pOQTY,
      this.rECEIVEDQTY,
      this.iTEMSYSID});

  LineItem.fromJson(Map<String, dynamic> json) {
    hEADSYSID = json['HEAD_SYS_ID'];
    iTEMCODE = json['ITEM_CODE'];
    iTEMNAME = json['ITEM_NAME'];
    gRADE = json['GRADE'];
    uOM = json['UOM'];
    pOQTY = json['PO_QTY'];
    rECEIVEDQTY = json['RECEIVED_QTY'];
    iTEMSYSID = json['ITEM_SYS_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['HEAD_SYS_ID'] = hEADSYSID;
    data['ITEM_CODE'] = iTEMCODE;
    data['ITEM_NAME'] = iTEMNAME;
    data['GRADE'] = gRADE;
    data['UOM'] = uOM;
    data['PO_QTY'] = pOQTY;
    data['RECEIVED_QTY'] = rECEIVEDQTY;
    data['ITEM_SYS_ID'] = iTEMSYSID;
    return data;
  }
}
