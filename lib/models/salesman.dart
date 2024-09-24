class Salesman {
  LISTOFSALESMANCODE? lISTOFSALESMANCODE;

  Salesman({this.lISTOFSALESMANCODE});

  Salesman.fromJson(Map<String, dynamic> json) {
    lISTOFSALESMANCODE = json['LISTOFSALESMANCODE'] != null
        ? LISTOFSALESMANCODE.fromJson(json['LISTOFSALESMANCODE'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lISTOFSALESMANCODE != null) {
      data['LISTOFSALESMANCODE'] = lISTOFSALESMANCODE!.toJson();
    }
    return data;
  }
}

class LISTOFSALESMANCODE {
  String? sMCODE;

  LISTOFSALESMANCODE({this.sMCODE});

  LISTOFSALESMANCODE.fromJson(Map<String, dynamic> json) {
    sMCODE = json['SM_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SM_CODE'] = sMCODE;
    return data;
  }
}
