class ItemCode {
  String? gTIN;
  String? itemCode;
  String? englishName;
  String? arabicName;
  String? lotNo;
  String? expiryDate;
  String? sERIALnUMBER;
  int? itemQty;
  int? size;
  String? wHLocation;
  String? binLocation;
  String? qRCodeInternational;
  String? modelName;
  String? productionDate;
  String? productType;
  String? brandName;
  String? packagingType;
  String? productUnit;
  String? productSize;
  String? createdAt;
  String? updatedAt;

  ItemCode({
    this.gTIN,
    this.itemCode,
    this.englishName,
    this.arabicName,
    this.lotNo,
    this.expiryDate,
    this.sERIALnUMBER,
    this.itemQty,
    this.size,
    this.wHLocation,
    this.binLocation,
    this.qRCodeInternational,
    this.modelName,
    this.productionDate,
    this.productType,
    this.brandName,
    this.packagingType,
    this.productUnit,
    this.productSize,
    this.createdAt,
    this.updatedAt,
  });

  ItemCode.fromJson(Map<String, dynamic> json) {
    gTIN = json['GTIN'];
    itemCode = json['ItemCode'];
    englishName = json['EnglishName'];
    arabicName = json['ArabicName'];
    lotNo = json['LotNo'];
    expiryDate = json['ExpiryDate'];
    sERIALnUMBER = json['sERIALnUMBER'];
    itemQty = json['ItemQty'];
    size = json['Size'];
    wHLocation = json['WHLocation'];
    binLocation = json['BinLocation'];
    qRCodeInternational = json['QRCodeInternational'];
    modelName = json['ModelName'];
    productionDate = json['ProductionDate'];
    productType = json['ProductType'];
    brandName = json['BrandName'];
    packagingType = json['PackagingType'];
    productUnit = json['ProductUnit'];
    productSize = json['ProductSize'];
    createdAt = json['Created_at'];
    updatedAt = json['Updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GTIN'] = gTIN;
    data['ItemCode'] = itemCode;
    data['EnglishName'] = englishName;
    data['ArabicName'] = arabicName;
    data['LotNo'] = lotNo;
    data['ExpiryDate'] = expiryDate;
    data['sERIALnUMBER'] = sERIALnUMBER;
    data['ItemQty'] = itemQty;
    data['Size'] = size;
    data['WHLocation'] = wHLocation;
    data['BinLocation'] = binLocation;
    data['QRCodeInternational'] = qRCodeInternational;
    data['ModelName'] = modelName;
    data['ProductionDate'] = productionDate;
    data['ProductType'] = productType;
    data['BrandName'] = brandName;
    data['PackagingType'] = packagingType;
    data['ProductUnit'] = productUnit;
    data['ProductSize'] = productSize;
    data['Created_at'] = createdAt;
    data['Updated_at'] = updatedAt;
    return data;
  }
}
