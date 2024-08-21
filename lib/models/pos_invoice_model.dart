class POSInvoiceModel {
  String? id;
  num? recNum;
  num? tblSysNoID;
  num? sNo;
  String? deliveryLocationCode;
  String? itemSysID;
  String? invoiceNo;
  String? headSYSID;
  String? transactionCode;
  String? customerCode;
  String? salesLocationCode;
  String? remarks;
  String? transactionType;
  String? userID;
  String? itemSKU;
  String? itemUnit;
  String? itemSize;
  num? iTEMRATE;
  num? itemPrice;
  num? itemQry;
  String? transactionDate;

  POSInvoiceModel({
    this.id,
    this.recNum,
    this.tblSysNoID,
    this.sNo,
    this.deliveryLocationCode,
    this.itemSysID,
    this.invoiceNo,
    this.headSYSID,
    this.transactionCode,
    this.customerCode,
    this.salesLocationCode,
    this.remarks,
    this.transactionType,
    this.userID,
    this.itemSKU,
    this.itemUnit,
    this.itemSize,
    this.iTEMRATE,
    this.itemPrice,
    this.itemQry,
    this.transactionDate,
  });

  POSInvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recNum = json['Rec_Num'];
    tblSysNoID = json['TblSysNoID'];
    sNo = json['SNo'];
    deliveryLocationCode = json['DeliveryLocationCode'];
    itemSysID = json['ItemSysID'];
    invoiceNo = json['InvoiceNo'];
    headSYSID = json['Head_SYS_ID'];
    transactionCode = json['TransactionCode'];
    customerCode = json['CustomerCode'];
    salesLocationCode = json['SalesLocationCode'];
    remarks = json['Remarks'];
    transactionType = json['TransactionType'];
    userID = json['UserID'];
    itemSKU = json['ItemSKU'];
    itemUnit = json['ItemUnit'];
    itemSize = json['ItemSize'];
    iTEMRATE = json['ITEMRATE'];
    itemPrice = json['ItemPrice'];
    itemQry = json['ItemQry'];
    transactionDate = json['TransactionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Rec_Num'] = recNum;
    data['TblSysNoID'] = tblSysNoID;
    data['SNo'] = sNo;
    data['DeliveryLocationCode'] = deliveryLocationCode;
    data['ItemSysID'] = itemSysID;
    data['InvoiceNo'] = invoiceNo;
    data['Head_SYS_ID'] = headSYSID;
    data['TransactionCode'] = transactionCode;
    data['CustomerCode'] = customerCode;
    data['SalesLocationCode'] = salesLocationCode;
    data['Remarks'] = remarks;
    data['TransactionType'] = transactionType;
    data['UserID'] = userID;
    data['ItemSKU'] = itemSKU;
    data['ItemUnit'] = itemUnit;
    data['ItemSize'] = itemSize;
    data['ITEMRATE'] = iTEMRATE;
    data['ItemPrice'] = itemPrice;
    data['ItemQry'] = itemQry;
    data['TransactionDate'] = transactionDate;
    return data;
  }
}
