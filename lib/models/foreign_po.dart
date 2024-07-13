class ForeignPo {
  List<Records>? records;
  int? totalRecords;
  int? currentPage;
  int? totalPages;

  ForeignPo({
    this.records,
    this.totalRecords,
    this.currentPage,
    this.totalPages,
  });

  ForeignPo.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    data['totalRecords'] = totalRecords;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    return data;
  }
}

class Records {
  int? tblPOFPOPMasterID;
  String? pONumber;
  String? pODate;
  String? supplierName;
  String? pOStatus;
  String? headSYSID;
  String? createdAt;
  String? updatedAt;

  Records(
      {this.tblPOFPOPMasterID,
      this.pONumber,
      this.pODate,
      this.supplierName,
      this.pOStatus,
      this.headSYSID,
      this.createdAt,
      this.updatedAt});

  Records.fromJson(Map<String, dynamic> json) {
    tblPOFPOPMasterID = json['tblPOFPOPMasterID'];
    pONumber = json['PONumber'];
    pODate = json['PODate'];
    supplierName = json['SupplierName'];
    pOStatus = json['POStatus'];
    headSYSID = json['Head_SYS_ID'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tblPOFPOPMasterID'] = tblPOFPOPMasterID;
    data['PONumber'] = pONumber;
    data['PODate'] = pODate;
    data['SupplierName'] = supplierName;
    data['POStatus'] = pOStatus;
    data['Head_SYS_ID'] = headSYSID;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
