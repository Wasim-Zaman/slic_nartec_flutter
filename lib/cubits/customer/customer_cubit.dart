import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/services/api_service.dart';

part 'customer_states.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerInitial());

  String? transaction,
      location,
      locationCode,
      deliveryLocation,
      deliveryLocationCode,
      customerName,
      delivery,
      deliveryInstruction,
      packingInstruction,
      billingInstruction,
      otherDetails,
      custRefNo,
      modeOfDelivery,
      deliveryContact,
      deliveryDate,
      lpoNumber,
      remarks,
      faxNo,
      transactionCode,
      refFromNo,
      refFrom,
      customerCode,
      salesLocation,
      salesLocationCode,
      deliverAfterDays;

  int quantity = 1, size = 1;

  addCustomerQuotation(List<ItemCode> items) async {
    try {
      emit(CustomerSaveQuotationLoading());
      final body = {
        "keyword": "Quotation",
        "secret-key": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          {
            "compCode": "SLIC",
            "LocnCode": "$locationCode",
            "CustomerName": "$customerName",
            "CQH_FLEX_01": "0",
            "CQH_FLEX_02": "0",
            "VAT": "0",
            "CQH_FLEX_04": "0",
            "Delivery": "$delivery",
            "Remarks": "$remarks",
            "FaxNo": "$faxNo",
            "TransactionCode": "$transactionCode",
            "RefFromNo": "$refFromNo",
            "RefFrom": "$refFrom",
            "CustCode": "$customerCode",
            "SalesLocn": "$salesLocationCode",
            "DeliveryAfterDays": "$deliverAfterDays",
            "Item": items
                .map(
                  (i) => {
                    "Item-Code": "${i.itemCode}",
                    "Size": "${i.productSize}",
                    "Rate": "55.0",
                    "Qty": "${i.itemQty}"
                  },
                )
                .toList()
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "SYSADMIN",
        "APICODE": "QUOTATIONCREATE",
        "LANG": "ENG"
      };

      jsonEncode(body);

      final response = await ApiService.slicPostData(body);
      if (bool.parse(response['success'])) {
        emit(CustomerSaveQuotationSuccess(
            message: response['message'].toString(),
            docNo: response['DocNo'].toString(),
            refNo: response['Ref-No/SysID'].toString()));
      } else {
        if (response.containsKey("message") && response.containsKey("error")) {
          emit(CustomerSaveQuotationError(
              message: "${response['message']} ${response['error']}"));
        } else if (response.containsKey("message")) {
          emit(CustomerSaveQuotationError(message: response['message']));
        } else if (response.containsKey("MESSAGE")) {
          emit(CustomerSaveQuotationError(message: response['MESSAGE']));
        }
      }
    } catch (error) {
      emit(CustomerSaveQuotationError(message: error.toString()));
    }
  }
}
