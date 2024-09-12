import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/invoice_header_and_details_model.dart';
import 'package:slic/models/item_sys_id_model.dart';
import 'package:slic/models/pos_invoice_model.dart';
import 'package:slic/models/transaction_code_model.dart';
import 'package:slic/services/api_service.dart';

part 'sales_return_states.dart';

class SalesReturnCubit extends Cubit<SalesReturnState> {
  SalesReturnCubit() : super(SalesReturnInitial());

  static SalesReturnCubit get(context) =>
      BlocProvider.of<SalesReturnCubit>(context);

  // Lists
  List<TransactionCodeModel> transactionCodes = [];
  List<POSInvoiceModel> invoices = [];
  List<POSInvoiceModel> selectedInvoices = [];
  List<ItemSysIdModel> itemSysIds = [];

  // Selected values
  String? transactionName;
  String? transactionCode;
  String? invoiceNumber;
  num? returnQty;

  InvoiceHeaderAndDetailsModel? invoiceDetails;

  void getPOSInvoice() async {
    emit(SalesReturnPOSInvoiceLoading());
    try {
      final response = await ApiService.getPOSDetailsByInvoice(
        invoiceNumber,
        transactionCode,
      );

      if (response.success) {
        invoices = response.data;
        emit(SalesReturnPOSInvoiceSuccess());
      } else {
        emit(SalesReturnPOSInvoiceError(errorMessage: response.message));
      }
    } catch (error) {
      emit(SalesReturnPOSInvoiceError(errorMessage: error.toString()));
    }
  }

  void getInvoiceHeadersAndDetails() async {
    emit(SalesReturnPOSInvoiceLoading());
    try {
      final response = await ApiService.getInvoiceHeaderDetails(invoiceNumber);

      if (response.success) {
        invoiceDetails = response.data;
        emit(SalesReturnPOSInvoiceSuccess());
      } else {
        emit(SalesReturnPOSInvoiceError(errorMessage: response.message));
      }
    } catch (error) {
      emit(SalesReturnPOSInvoiceError(errorMessage: error.toString()));
    }
  }

  getTransactionCodes() async {
    emit(SalesReturnTransactionCodesLoading());
    try {
      final response = await ApiService.slicGetData({
        "filter": {"P_TXN_TYPE": "LTRFO"},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ListOfTransactionCode",
        "M_LANG_CODE": "ENG"
      });

      response.forEach((element) {
        transactionCodes.add(TransactionCodeModel.fromJson(element));
      });

      emit(SalesReturnTransactionCodesSuccess());
    } catch (error) {
      emit(SalesReturnTransactionCodesError(errorMessage: error.toString()));
    }
  }

  void updateInvoiceTemp(itemSysID, itemCode) async {
    try {
      emit(SalesReturnUpdateTempLoading());
      final response =
          await ApiService.updateInvoiceTemp(itemSysID, itemCode, returnQty);

      if (response.success) {
        emit(SalesReturnUpdateTempSuccess(successMessage: response.message));
      } else {
        emit(SalesReturnUpdateTempError(errorMessage: response.message));
      }
    } catch (error) {
      emit(SalesReturnUpdateTempError(errorMessage: error.toString()));
    }
  }

  saveSalesInvoice(paymentMode, taxReason) async {
    try {
      emit(SalesReturnSaveInvoiceLoading());

      final data = [
        {
          "SessionId": "102202216451",
          "Company": "SLIC",
          "HeadSysId":
              "${invoiceDetails?.invoiceHeader?.headSYSID?.toString().replaceAll(" ", "")}",
          "TransactionCode": "$transactionCode",
          "TransactionNo": "${invoiceDetails?.invoiceHeader?.invoiceNo}",
          "DeliveryLocationCode":
              "${invoiceDetails?.invoiceHeader?.deliveryLocationCode}",
          "SystemId": "SYSADMIN",
          "ZATCAPaymentMode": "$paymentMode",
          "TaxExemptionReason": "$taxReason",
          "Item": invoiceDetails?.invoiceDetails
              ?.map((details) => {
                    "SessionId": "102202216451",
                    "HeadSysId":
                        "${details.headSYSID?.toString().replaceAll(" ", "")}",
                    "ItemSysId": "${details.itemSysID}",
                    "Item-Code": "${details.itemSKU}",
                    "ItemDescription": "${details.remarks}",
                    "Size": "${details.itemSize}",
                    "UnitCode": "${details.itemUnit}",
                    "ReceivedQty": "${details.itemQry}",
                    "SystemId": "SYSADMIN"
                  })
              .toList(),
        }
      ];
      final body = {
        "_keyword_": "InvoiceToSR",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": data,
        "COMPANY": "SLIC",
        "USERID": "SYSADMIN",
        "APICODE": "InvoiceToSR",
        "LANG": "ENG"
      };

      log(jsonEncode(body));
      final response = await ApiService.slicPostData(body);

      print(response);

      if (response.containsKey("error")) {
        emit(SalesReturnSaveInvoiceError(errorMessage: response['error']));
      } else if (response.containsKey("MESSAGE")) {
        emit(
          SalesReturnSaveInvoiceSuccess(
            successMessage: response['MESSAGE'],
            salesReturnSysId: response['SALESRETURN_SYS_ID'],
            salesReturnDocNo: response['SALESRETURN_DOC_NO'],
          ),
        );
      }
      // emit(SalesReturnSaveInvoiceError(errorMessage: response.message));
    } catch (error) {
      emit(SalesReturnSaveInvoiceError(errorMessage: error.toString()));
    }
  }

  getItemSysIdsByHeadSysId(headSysId) async {
    try {
      final response = await ApiService.slicGetData({
        "filter": {"P_HEAD_SYS_ID": "$headSysId"},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "INVOICEITEMDETAILS",
        "M_LANG_CODE": "ENG"
      });

      itemSysIds.clear();
      response.forEach((item) {
        itemSysIds.add(ItemSysIdModel.fromJson(item));
      });

      print(invoiceDetails?.invoiceDetails?.length);
      print(itemSysIds.length);

      invoiceDetails?.invoiceDetails?.forEach((element) {
        for (var item in itemSysIds) {
          if (element.itemSKU == item.iNVOICEITEMDETAILS?.iNVIITEMCODE) {
            print("changed");
            element.itemSysID = item.iNVOICEITEMDETAILS?.iNVISYSID.toString();
          }
        }
        emit(SalesReturnChangedItemSysId());
      });
    } catch (error) {
      print(error);
    }
  }
}
