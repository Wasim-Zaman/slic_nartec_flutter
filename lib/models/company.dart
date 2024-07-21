class CompanyModel {
  String? cOMPCODE;
  String? cOMPNAME;

  CompanyModel({this.cOMPCODE, this.cOMPNAME});

  CompanyModel.fromJson(Map<String, dynamic> json) {
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
