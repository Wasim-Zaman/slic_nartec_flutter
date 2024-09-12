class TaxEcemptionReasonModel {
  TAXEXEMPTIONREASON? tAXEXEMPTIONREASON;

  TaxEcemptionReasonModel({this.tAXEXEMPTIONREASON});

  TaxEcemptionReasonModel.fromJson(Map<String, dynamic> json) {
    tAXEXEMPTIONREASON = json['TAXEXEMPTIONREASON'] != null
        ? TAXEXEMPTIONREASON.fromJson(json['TAXEXEMPTIONREASON'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tAXEXEMPTIONREASON != null) {
      data['TAXEXEMPTIONREASON'] = tAXEXEMPTIONREASON!.toJson();
    }
    return data;
  }
}

class TAXEXEMPTIONREASON {
  String? vSSVCODE;
  String? vSSVNAME;

  TAXEXEMPTIONREASON({this.vSSVCODE, this.vSSVNAME});

  TAXEXEMPTIONREASON.fromJson(Map<String, dynamic> json) {
    vSSVCODE = json['VSSV_CODE'];
    vSSVNAME = json['VSSV_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VSSV_CODE'] = vSSVCODE;
    data['VSSV_NAME'] = vSSVNAME;
    return data;
  }
}
