import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nice_json/nice_json.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/services/api_service.dart';
import 'package:slic/utils/shared_storage.dart';

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
      flex1,
      flex2,
      flex4,
      vat,
      packingInstruction,
      billingInstruction,
      otherDetails,
      custRefNo,
      modeOfDelivery,
      deliveryContact,
      lpoNumber,
      remarks,
      faxNo,
      transactionCode,
      refFromNo,
      refFrom,
      customerCode,
      salesLocation,
      salesLocationCode,
      salesman,
      paymentTerm,
      deliverAfterDays,
      lcNo;

  int quantity = 1, size = 1;

  final deliveryDate = TextEditingController();
  final lcValidDate = TextEditingController();

  setDeliveryDate(DateTime selectedDate) {
    deliveryDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    emit(CustomerDateChanged());
  }

  setLcValiddate(DateTime selectedDate) {
    lcValidDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    emit(CustomerDateChanged());
  }

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
            "CQH_FLEX_01": "$flex1",
            "CQH_FLEX_02": "$flex2",
            "VAT": "$vat",
            "CQH_FLEX_04": "$flex4",
            "Delivery": "$delivery",
            "Remarks": "$remarks",
            "FaxNo": "$faxNo",
            "TransactionCode": "$transactionCode",
            "RefFromNo": "1",
            "RefFrom": "D",
            "CustCode": "$customerCode",
            "SalesLocn": "$salesLocationCode",
            "DeliveryAfterDays": "$deliverAfterDays",
            "Salesman": "$salesman",
            "PaymentTerm": "$paymentTerm",
            "Item": items
                .map(
                  (i) => {
                    "Item-Code": "${i.itemCode}",
                    "Size": "${i.productSize}",
                    "Rate": "${i.rate}",
                    "Qty": "${i.itemQty}"
                  },
                )
                .toList()
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "${SharedStorage.getEmail()}",
        "APICODE": "QUOTATIONCREATE",
        "LANG": "ENG"
      };

      jsonEncode(body);

      final response = await ApiService.slicPostData(body);

      if (bool.parse(response['success'])) {
        emit(CustomerSaveQuotationSuccess(
            // message: response['message'].toString(),
            message: niceJson(response),
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

  saveOrder(List<ItemCode> items) async {
    try {
      emit(CustomerSaveQuotationLoading());

      final item = items
          .map(
            (i) => {
              "Item-Code": "${i.itemCode}",
              "Size": "${i.productSize}",
              "Rate": "${i.rate}",
              "Qty": "${i.itemQty}",
              "UserId": "${SharedStorage.getEmail()}"
            },
          )
          .toList();

      final body = {
        "keyword": "SALESORDER",
        "secret-key": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          {
            "DeliveryLocationCode": "$deliveryLocationCode",
            "SalesLocationCode": "$salesLocationCode",
            "Company": "SLIC",
            "UserId": "${SharedStorage.getEmail()}",
            "TransactionCode": "$transactionCode",
            "CustomerCode": "$customerCode",
            "DeliveryInstruction": "$deliveryInstruction",
            "PackingInstruction": "$packingInstruction",
            "BillingInstruction": "$billingInstruction",
            "OtherDetails": "$otherDetails",
            "CustRefNo": "$custRefNo",
            "ModeOfDelivery": "$modeOfDelivery",
            "DeliveryContact": "$deliveryContact",
            "DeliveryDate": deliveryDate.text,
            "LcNo": "$lcNo",
            "LcValidDate": lcValidDate.text,
            "Item": item,
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "${SharedStorage.getEmail()}",
        "APICODE": "SALESORDERCREATE",
        "LANG": "ENG"
      };

      jsonEncode(body);

      final response = await ApiService.slicPostData(body);

      if (bool.parse(response['success'])) {
        emit(CustomerSaveQuotationSuccess(
            // message: response['message'].toString(),
            message: niceJson(response),
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
