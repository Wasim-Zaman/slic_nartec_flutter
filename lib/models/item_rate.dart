class ItemRate {
  PRICELIST? pRICELIST;

  ItemRate({this.pRICELIST});

  ItemRate.fromJson(Map<String, dynamic> json) {
    pRICELIST = json['PRICELIST'] != null
        ? PRICELIST.fromJson(json['PRICELIST'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pRICELIST != null) {
      data['PRICELIST'] = pRICELIST!.toJson();
    }
    return data;
  }
}

class PRICELIST {
  int? pLIRATE;

  PRICELIST({this.pLIRATE});

  PRICELIST.fromJson(Map<String, dynamic> json) {
    pLIRATE = json['PLI_RATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PLI_RATE'] = pLIRATE;
    return data;
  }
}
