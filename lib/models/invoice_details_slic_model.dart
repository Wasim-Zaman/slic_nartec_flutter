class InvoiceDetailsSlicModel {
  INVTOSRITEMDETAILS? iNVTOSRITEMDETAILS;

  InvoiceDetailsSlicModel({this.iNVTOSRITEMDETAILS});

  InvoiceDetailsSlicModel.fromJson(Map<String, dynamic> json) {
    iNVTOSRITEMDETAILS = json['INVTOSRITEMDETAILS'] != null
        ? INVTOSRITEMDETAILS.fromJson(json['INVTOSRITEMDETAILS'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (iNVTOSRITEMDETAILS != null) {
      data['INVTOSRITEMDETAILS'] = iNVTOSRITEMDETAILS!.toJson();
    }
    return data;
  }
}

class INVTOSRITEMDETAILS {
  num? iNVISYSID;
  num? iNVIINVHSYSID;
  num? iNVHNO;
  String? iNVIITEMCODE;
  String? iNVIITEMDESC;
  num? iNVIQTY;
  String? iNVIGRADECODE1;
  String? iNVIGRADECODE2;
  String? iNVIUOMCODE;

  INVTOSRITEMDETAILS(
      {this.iNVISYSID,
      this.iNVIINVHSYSID,
      this.iNVHNO,
      this.iNVIITEMCODE,
      this.iNVIITEMDESC,
      this.iNVIQTY,
      this.iNVIGRADECODE1,
      this.iNVIGRADECODE2,
      this.iNVIUOMCODE});

  INVTOSRITEMDETAILS.fromJson(Map<String, dynamic> json) {
    iNVISYSID = json['INVI_SYS_ID'];
    iNVIINVHSYSID = json['INVI_INVH_SYS_ID'];
    iNVHNO = json['INVH_NO'];
    iNVIITEMCODE = json['INVI_ITEM_CODE'];
    iNVIITEMDESC = json['INVI_ITEM_DESC'];
    iNVIQTY = json['INVI_QTY'];
    iNVIGRADECODE1 = json['INVI_GRADE_CODE_1'];
    iNVIGRADECODE2 = json['INVI_GRADE_CODE_2'];
    iNVIUOMCODE = json['INVI_UOM_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['INVI_SYS_ID'] = iNVISYSID;
    data['INVI_INVH_SYS_ID'] = iNVIINVHSYSID;
    data['INVH_NO'] = iNVHNO;
    data['INVI_ITEM_CODE'] = iNVIITEMCODE;
    data['INVI_ITEM_DESC'] = iNVIITEMDESC;
    data['INVI_QTY'] = iNVIQTY;
    data['INVI_GRADE_CODE_1'] = iNVIGRADECODE1;
    data['INVI_GRADE_CODE_2'] = iNVIGRADECODE2;
    data['INVI_UOM_CODE'] = iNVIUOMCODE;
    return data;
  }
}
