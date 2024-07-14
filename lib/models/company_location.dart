class Company {
  int? tblSysNoID;
  String? companyCode;
  String? companyName;

  Company({this.tblSysNoID, this.companyCode, this.companyName});

  Company.fromJson(Map<String, dynamic> json) {
    tblSysNoID = json['TblSysNoID'];
    companyCode = json['CompanyCode'];
    companyName = json['CompanyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TblSysNoID'] = tblSysNoID;
    data['CompanyCode'] = companyCode;
    data['CompanyName'] = companyName;
    return data;
  }
}

class Location {
  int? tblSysNoID;
  String? locationCode;
  String? locationName;

  Location({this.tblSysNoID, this.locationCode, this.locationName});

  Location.fromJson(Map<String, dynamic> json) {
    tblSysNoID = json['TblSysNoID'];
    locationCode = json['LocationCode'];
    locationName = json['LocationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TblSysNoID'] = tblSysNoID;
    data['LocationCode'] = locationCode;
    data['LocationName'] = locationName;
    return data;
  }
}

class CompanyLocation {
  List<Location>? locations;
  List<Company>? companies;

  CompanyLocation({this.locations, this.companies});

  CompanyLocation.fromJson(Map<String, dynamic> json) {
    if (json['locations'] != null) {
      locations = <Location>[];
      json['locations'].forEach((v) {
        locations?.add(Location.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companies = <Company>[];
      json['companies'].forEach((v) {
        companies?.add(Company.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
