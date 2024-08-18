import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/transaction_code_model.dart';
import 'package:slic/services/api_service.dart';

part 'goods_issue_state.dart';

class GoodsIssueCubit extends Cubit<GoodsIssueState> {
  GoodsIssueCubit() : super(GoodsIssueInitia());

  static GoodsIssueCubit get(context) => BlocProvider.of(context);

  // Lists
  List<ItemCode> itemCodes = [];
  List<TransactionCodeModel> transactionCodes = [];

  String? transactionName, transactionCode;
  String? gtin;
  int boxQuantity = 1;
  int size = 37;
  String type = "U";
  double total = 0;

  // Selected values
  int quantity = 1;
  // Add your cubit methods here

  void dispose() {
    itemCodes.clear();
    gtin = null;
    boxQuantity = 1;
    size = 1;
    type = "U";
    total = 0;
  }

  getTransactionCodes() async {
    emit(GoodsIssueTransactionCodesLoading());
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

      emit(GoodsIssueTransactionCodesSuccess());
    } catch (error) {
      emit(GoodsIssueTransactionCodesError(errorMessage: error.toString()));
    }
  }

  void transferStock({
    required List<ItemCode> itemCodes,
    String? fromLocationCode,
    String? toLocationCode,
  }) async {
    emit(GoodsIssuePostLoading());
    try {
      final body = {
        "_keyword_": "LTO",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          {
            "Company": "SLIC",
            "TransactionCode": transactionCode.toString(),
            "FromLocation-Code": fromLocationCode.toString(),
            "ToLocation-Code": toLocationCode.toString(),
            "UserId": "SYSADMIN",
            "CustomerName": "ABC",
            "MobileNo": 805630,
            "Remarks": "good",
            "Item": itemCodes
                .map(
                  (e) => {
                    "ItemCode": e.itemCode.toString(),
                    "Size": "${e.size}",
                    "Qty": "${e.itemQty}",
                    "UserId": "SYSADMIN"
                  },
                )
                .toList(),
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "SYSADMIN",
        "APICODE": "STOCKTRANSFER",
        "LANG": "ENG"
      };

      log(jsonEncode(body));
      final response = await ApiService.slicPostData(body);
      emit(GoodsIssuePostSuccess(message: response.toString()));
    } catch (e) {
      print(e);
      emit(GoodsIssuePostError(errorMessage: e.toString()));
    }
  }
}
