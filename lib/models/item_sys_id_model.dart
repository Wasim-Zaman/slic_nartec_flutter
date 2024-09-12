class ItemSysIdModel {
  INVOICEITEMDETAILS? iNVOICEITEMDETAILS;

  ItemSysIdModel({this.iNVOICEITEMDETAILS});

  ItemSysIdModel.fromJson(Map<String, dynamic> json) {
    iNVOICEITEMDETAILS = json['INVOICEITEMDETAILS'] != null
        ? INVOICEITEMDETAILS.fromJson(json['INVOICEITEMDETAILS'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (iNVOICEITEMDETAILS != null) {
      data['INVOICEITEMDETAILS'] = iNVOICEITEMDETAILS!.toJson();
    }
    return data;
  }
}

class INVOICEITEMDETAILS {
  int? iNVISYSID;
  String? iNVIITEMCODE;
  String? iNVIITEMDESC;
  int? iNVIQTY;
  String? iNVIGRADECODE1;
  String? iNVIGRADECODE2;

  INVOICEITEMDETAILS(
      {this.iNVISYSID,
      this.iNVIITEMCODE,
      this.iNVIITEMDESC,
      this.iNVIQTY,
      this.iNVIGRADECODE1,
      this.iNVIGRADECODE2});

  INVOICEITEMDETAILS.fromJson(Map<String, dynamic> json) {
    iNVISYSID = json['INVI_SYS_ID'];
    iNVIITEMCODE = json['INVI_ITEM_CODE'];
    iNVIITEMDESC = json['INVI_ITEM_DESC'];
    iNVIQTY = json['INVI_QTY'];
    iNVIGRADECODE1 = json['INVI_GRADE_CODE_1'];
    iNVIGRADECODE2 = json['INVI_GRADE_CODE_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['INVI_SYS_ID'] = iNVISYSID;
    data['INVI_ITEM_CODE'] = iNVIITEMCODE;
    data['INVI_ITEM_DESC'] = iNVIITEMDESC;
    data['INVI_QTY'] = iNVIQTY;
    data['INVI_GRADE_CODE_1'] = iNVIGRADECODE1;
    data['INVI_GRADE_CODE_2'] = iNVIGRADECODE2;
    return data;
  }
}
