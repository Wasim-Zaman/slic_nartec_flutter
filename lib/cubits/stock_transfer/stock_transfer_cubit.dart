import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_json/nice_json.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/transaction_code_model.dart';
import 'package:slic/services/api_service.dart';
import 'package:slic/utils/shared_storage.dart';

part 'stock_transfer_states.dart';

class StockTransferCubit extends Cubit<StockTransferState> {
  StockTransferCubit() : super(StockTransferInitial());

  static StockTransferCubit get(context) =>
      BlocProvider.of<StockTransferCubit>(context);

  // Variables

  // Lists
  List<ItemCode> itemCodes = [];
  List<TransactionCodeModel> transactionCodes = [];

  String? gtin;
  int boxQuantity = 1;
  int size = 37;
  String type = "U";
  double total = 0;

  // Selected values
  String? transactionName;
  String? transactionCode;
  int quantity = 1;

  void dispose() {
    itemCodes.clear();
    gtin = null;
    boxQuantity = 1;
    size = 1;
    type = "U";
    total = 0;
  }

  getTransactionCodes() async {
    emit(StockTransferTransactionCodesLoading());
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

      emit(StockTransferTransactionCodesSuccess());
    } catch (error) {
      emit(StockTransferTransactionCodesError(errorMessage: error.toString()));
    }
  }

  void transferStock({
    required List<ItemCode> itemCodes,
    String? fromLocationCode,
    String? toLocationCode,
  }) async {
    emit(StockTransferPostLoading());
    try {
      final item = itemCodes.map(
        (e) {
          String? ic;
          if (transactionCode == "PITO") {
            if (type == "U") {
              ic = "U${e.itemCode}";
            } else {
              ic = "U${e.itemCode}$type";
            }
          } else {
            ic = e.itemCode;
          }
          return {
            "ItemCode": "$ic",
            "Size": "${e.productSize}",
            "Qty": "${e.itemQty}",
            "UserId": "${SharedStorage.getEmail()}"
          };
        },
      ).toList();

      final body = {
        "_keyword_": "LTO",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          {
            "Company": "SLIC",
            "TransactionCode": transactionCode.toString(),
            "FromLocation-Code": "$fromLocationCode",
            "ToLocation-Code": "$toLocationCode",
            "UserId": "${SharedStorage.getEmail()}",
            "Item": item,
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "${SharedStorage.getEmail()}",
        "APICODE": "STOCKTRANSFER",
        "LANG": "ENG"
      };

      log(jsonEncode(body));
      final response = await ApiService.slicPostData(body);
      if (response['success'] == "true") {
        emit(StockTransferPostSuccess(
          message: niceJson(response),
        ));
      } else {
        if (response.containsKey("error")) {
          emit(StockTransferPostError(errorMessage: response["error"]));
        } else {
          emit(StockTransferPostError(errorMessage: response.toString()));
        }
      }
    } catch (e) {
      emit(StockTransferPostError(
          errorMessage: "Error occurred while transferring stock!"));
    }
  }
}
