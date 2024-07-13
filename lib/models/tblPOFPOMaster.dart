class POFPOMaster {
  int? tblPOFPOMasterID;
  String? pONumber;
  String? pODate;
  String? supplierName;
  String? pOStatus;
  String? headSYSID;
  String? createdAt;
  String? updatedAt;

  POFPOMaster(
      {this.tblPOFPOMasterID,
      this.pONumber,
      this.pODate,
      this.supplierName,
      this.pOStatus,
      this.headSYSID,
      this.createdAt,
      this.updatedAt});

  POFPOMaster.fromJson(Map<String, dynamic> json) {
    tblPOFPOMasterID = json['tblPOFPOMasterID'];
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
    data['tblPOFPOMasterID'] = tblPOFPOMasterID;
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
