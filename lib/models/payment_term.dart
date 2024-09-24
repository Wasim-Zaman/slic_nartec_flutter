class PaymentTerm {
  LISTOFPAYMENTTERM? lISTOFPAYMENTTERM;

  PaymentTerm({this.lISTOFPAYMENTTERM});

  PaymentTerm.fromJson(Map<String, dynamic> json) {
    lISTOFPAYMENTTERM = json['LISTOFPAYMENTTERM'] != null
        ? LISTOFPAYMENTTERM.fromJson(json['LISTOFPAYMENTTERM'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lISTOFPAYMENTTERM != null) {
      data['LISTOFPAYMENTTERM'] = lISTOFPAYMENTTERM!.toJson();
    }
    return data;
  }
}

class LISTOFPAYMENTTERM {
  String? cPTTERMCODE;

  LISTOFPAYMENTTERM({this.cPTTERMCODE});

  LISTOFPAYMENTTERM.fromJson(Map<String, dynamic> json) {
    cPTTERMCODE = json['CPT_TERM_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CPT_TERM_CODE'] = cPTTERMCODE;
    return data;
  }
}
