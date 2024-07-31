class SlicLineItemModel {
  ListOfPOItem? listOfPOItem;

  SlicLineItemModel({this.listOfPOItem});

  SlicLineItemModel.fromJson(Map<String, dynamic> json) {
    listOfPOItem = json['ListOfPOItem'] != null
        ? ListOfPOItem.fromJson(json['ListOfPOItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listOfPOItem != null) {
      data['ListOfPOItem'] = listOfPOItem!.toJson();
    }
    return data;
  }
}

class ListOfPOItem {
  String? iTEMCODE;
  String? iTEMNAME;
  String? gRADE;
  String? uOM;
  int? pOQTY;
  String? rECEIVEDQTY;
  int? iTEMSYSID;

  ListOfPOItem(
      {this.iTEMCODE,
      this.iTEMNAME,
      this.gRADE,
      this.uOM,
      this.pOQTY,
      this.rECEIVEDQTY,
      this.iTEMSYSID});

  ListOfPOItem.fromJson(Map<String, dynamic> json) {
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
