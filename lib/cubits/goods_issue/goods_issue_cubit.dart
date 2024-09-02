import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/transaction_code_model.dart';
import 'package:slic/services/api_service.dart';

part 'goods_issue_state.dart';

class GoodsIssueCubit extends Cubit<GoodsIssueState> {
  GoodsIssueCubit() : super(GoodsIssueInitia());

  static GoodsIssueCubit get(context) => BlocProvider.of(context);

  // Lists
  List<TransactionCodeModel> transactionCodes = [];

  String? transactionName, transactionCode;
  String? gtin;
  int boxQuantity = 1;
  int size = 1;
  String type = "U";
  int total = 0;
  final date = TextEditingController();

  // Selected values
  int quantity = 1;
  // Add your cubit methods here

  void dispose() {
    emit(GoodsIssueInitia());
    gtin = null;
    boxQuantity = 1;
    size = 1;
    type = "U";
    total = 0;
    transactionName = null;
    transactionCode = null;
    date.clear();
  }

  setDate() {
    date.text = DateFormat.yMd().format(DateTime.now().toUtc());
    emit(GoodsIssueDateChanged());
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

  void submitGoods({
    required List<ItemCode> itemCodes,
    String? fromLocationCode,
    String? toLocationCode,
  }) async {
    emit(GoodsIssuePostLoading());
    final body = {
      "_keyword_": "Production",
      "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
      "data": [
        {
          "Company": "SLIC",
          // "FromLocation-Code": fromLocationCode.toString(),
          // "ToLocation-Code": toLocationCode.toString(),
          "UserId": "SYSADMIN",
          "TransactionCode": transactionCode.toString(),
          "LocationCode": fromLocationCode.toString(),
          "UserID": "SYSADMIN",
          "ProductionDate": date.text.toString(),
          // "CustomerName": "ABC",
          // "MobileNo": 805630,
          // "Remarks": "good",
          "Item": itemCodes
              .map(
                (e) => {
                  "Item-Code": e.itemCode.toString(),
                  // "Size": "${e.size}",
                  "Size": "${e.productSize}",
                  "Qty": "${e.itemQty}",
                  "UserID": "SYSADMIN"
                },
              )
              .toList(),
        }
      ],
      "COMPANY": "SLIC",
      "USERID": "SYSADMIN",
      "APICODE": "PRODUCTIONWO",
      "LANG": "ENG"
    };

    log(jsonEncode(body));
    final response = await ApiService.slicPostData(body);
    if (response['message'].isNotEmpty) {
      emit(GoodsIssuePostError(errorMessage: response['message']));
    } else {
      emit(GoodsIssuePostSuccess(message: "Goods Issue posted successfully"));
    }
  }
}
