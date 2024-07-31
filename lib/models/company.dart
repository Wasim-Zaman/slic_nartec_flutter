class CompanyModel {
  CompanyMaster? companyMaster;

  CompanyModel({this.companyMaster});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    companyMaster = json['CompanyMaster'] != null
        ? CompanyMaster.fromJson(json['CompanyMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyMaster != null) {
      data['CompanyMaster'] = companyMaster!.toJson();
    }
    return data;
  }
}

class CompanyMaster {
  String? cOMPCODE;
  String? cOMPNAME;

  CompanyMaster({this.cOMPCODE, this.cOMPNAME});

  CompanyMaster.fromJson(Map<String, dynamic> json) {
    cOMPCODE = json['COMP_CODE'];
    cOMPNAME = json['COMP_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['COMP_CODE'] = cOMPCODE;
    data['COMP_NAME'] = cOMPNAME;
    return data;
  }
}
