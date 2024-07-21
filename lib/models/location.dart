class LocationModel {
  String? lOCNCODE;
  String? lOCNNAME;

  LocationModel({this.lOCNCODE, this.lOCNNAME});

  LocationModel.fromJson(Map<String, dynamic> json) {
    lOCNCODE = json['LOCN_CODE'];
    lOCNNAME = json['LOCN_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LOCN_CODE'] = lOCNCODE;
    data['LOCN_NAME'] = lOCNNAME;
    return data;
  }
}
