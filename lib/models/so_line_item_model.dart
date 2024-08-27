class SoLineItemModel {
  ListOfSOItem? listOfSOItem;

  SoLineItemModel({this.listOfSOItem});

  SoLineItemModel.fromJson(Map<String, dynamic> json) {
    listOfSOItem = json['ListOfSOItem'] != null
        ? ListOfSOItem.fromJson(json['ListOfSOItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listOfSOItem != null) {
      data['ListOfSOItem'] = listOfSOItem!.toJson();
    }
    return data;
  }
}

class ListOfSOItem {
  int? iTEMSYSID;
  String? iTEMCODE;
  String? iTEMNAME;
  String? uOM;
  String? gRADE;
  int? sOQTY;
  String? iNVQTY;

  ListOfSOItem(
      {this.iTEMSYSID,
      this.iTEMCODE,
      this.iTEMNAME,
      this.uOM,
      this.gRADE,
      this.sOQTY,
      this.iNVQTY});

  ListOfSOItem.fromJson(Map<String, dynamic> json) {
    iTEMSYSID = json['ITEM_SYS_ID'];
    iTEMCODE = json['ITEM_CODE'];
    iTEMNAME = json['ITEM_NAME'];
    uOM = json['UOM'];
    gRADE = json['GRADE'];
    sOQTY = json['SO_QTY'];
    iNVQTY = json['INV_QTY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_SYS_ID'] = iTEMSYSID;
    data['ITEM_CODE'] = iTEMCODE;
    data['ITEM_NAME'] = iTEMNAME;
    data['UOM'] = uOM;
    data['GRADE'] = gRADE;
    data['SO_QTY'] = sOQTY;
    data['INV_QTY'] = iNVQTY;
    return data;
  }
}
