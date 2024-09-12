class InvoiceHeaderAndDetailsModel {
  InvoiceHeader? invoiceHeader;
  List<InvoiceDetails>? invoiceDetails;

  InvoiceHeaderAndDetailsModel({this.invoiceHeader, this.invoiceDetails});

  InvoiceHeaderAndDetailsModel.fromJson(Map<String, dynamic> json) {
    invoiceHeader = json['invoiceHeader'] != null
        ? InvoiceHeader.fromJson(json['invoiceHeader'])
        : null;
    if (json['invoiceDetails'] != null) {
      invoiceDetails = <InvoiceDetails>[];
      json['invoiceDetails'].forEach((v) {
        invoiceDetails!.add(InvoiceDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (invoiceHeader != null) {
      data['invoiceHeader'] = invoiceHeader!.toJson();
    }
    if (invoiceDetails != null) {
      data['invoiceDetails'] = invoiceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceHeader {
  Object? recNum;
  Object? tblSysNoID;
  Object? sNo;
  String? deliveryLocationCode;
  String? itemSysID;
  String? invoiceNo;
  Object? headSYSID;
  String? transactionCode;
  String? customerCode;
  String? salesLocationCode;
  String? remarks;
  String? transactionType;
  String? userID;
  String? mobileNo;
  String? transactionDate;
  String? id;
  String? vatNumber;
  String? customerName;
  int? adjAmount;
  String? docNo;
  int? pendingAmount;

  InvoiceHeader(
      {this.recNum,
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
      this.mobileNo,
      this.transactionDate,
      this.id,
      this.vatNumber,
      this.customerName,
      this.adjAmount,
      this.docNo,
      this.pendingAmount});

  InvoiceHeader.fromJson(Map<String, dynamic> json) {
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
    mobileNo = json['MobileNo'];
    transactionDate = json['TransactionDate'];
    id = json['id'];
    vatNumber = json['VatNumber'];
    customerName = json['CustomerName'];
    adjAmount = json['AdjAmount'];
    docNo = json['DocNo'];
    pendingAmount = json['PendingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['MobileNo'] = mobileNo;
    data['TransactionDate'] = transactionDate;
    data['id'] = id;
    data['VatNumber'] = vatNumber;
    data['CustomerName'] = customerName;
    data['AdjAmount'] = adjAmount;
    data['DocNo'] = docNo;
    data['PendingAmount'] = pendingAmount;
    return data;
  }
}

class InvoiceDetails {
  int? recNum;
  int? tblSysNoID;
  int? sNo;
  String? deliveryLocationCode;
  String? itemSysID;
  String? invoiceNo;
  Object? headSYSID;
  String? transactionCode;
  String? customerCode;
  String? salesLocationCode;
  String? remarks;
  String? transactionType;
  String? userID;
  String? itemSKU;
  String? itemUnit;
  String? itemSize;
  int? iTEMRATE;
  int? itemPrice;
  int? itemQry;
  String? transactionDate;
  String? id;
  num? returnQty;
  bool? changed = false;

  InvoiceDetails({
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
    this.id,
    this.changed,
    this.returnQty,
  });

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
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
    id = json['id'];
    returnQty = json['ReturnQty'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['id'] = id;
    return data;
  }
}
