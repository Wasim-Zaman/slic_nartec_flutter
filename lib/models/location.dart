class LocationModel {
  LocationMaster? locationMaster;

  LocationModel({this.locationMaster});

  LocationModel.fromJson(Map<String, dynamic> json) {
    locationMaster = json['LocationMaster'] != null
        ? LocationMaster.fromJson(json['LocationMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (locationMaster != null) {
      data['LocationMaster'] = locationMaster!.toJson();
    }
    return data;
  }
}

class LocationMaster {
  String? lOCNCODE;
  String? lOCNNAME;

  LocationMaster({this.lOCNCODE, this.lOCNNAME});

  LocationMaster.fromJson(Map<String, dynamic> json) {
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
