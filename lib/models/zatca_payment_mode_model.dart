class ZatcaPaymentModeModel {
  ZATCAPAYMENTMODE? zATCAPAYMENTMODE;

  ZatcaPaymentModeModel({this.zATCAPAYMENTMODE});

  ZatcaPaymentModeModel.fromJson(Map<String, dynamic> json) {
    zATCAPAYMENTMODE = json['ZATCAPAYMENTMODE'] != null
        ? ZATCAPAYMENTMODE.fromJson(json['ZATCAPAYMENTMODE'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (zATCAPAYMENTMODE != null) {
      data['ZATCAPAYMENTMODE'] = zATCAPAYMENTMODE!.toJson();
    }
    return data;
  }
}

class ZATCAPAYMENTMODE {
  String? vSSVCODE;
  String? vSSVNAME;

  ZATCAPAYMENTMODE({this.vSSVCODE, this.vSSVNAME});

  ZATCAPAYMENTMODE.fromJson(Map<String, dynamic> json) {
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
