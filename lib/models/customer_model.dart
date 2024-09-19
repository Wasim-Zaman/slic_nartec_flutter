class CustomerModel {
  String? cUSTCODE;
  String? cUSTNAME;

  CustomerModel({this.cUSTCODE, this.cUSTNAME});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    cUSTCODE = json['CUST_CODE'];
    cUSTNAME = json['CUST_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CUST_CODE'] = cUSTCODE;
    data['CUST_NAME'] = cUSTNAME;
    return data;
  }
}
