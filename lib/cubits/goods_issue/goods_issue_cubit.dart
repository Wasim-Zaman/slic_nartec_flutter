import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nice_json/nice_json.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/transaction_code_model.dart';
import 'package:slic/services/api_service.dart';
import 'package:slic/utils/shared_storage.dart';

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

  // init
  void init() {
    getTransactionCodes();
    emit(GoodsIssueInitia());
  }

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

  setDate(DateTime selectedDate) {
    date.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    emit(GoodsIssueDateChanged());
  }

  getTransactionCodes({String txnType = "LTRFO"}) async {
    emit(GoodsIssueTransactionCodesLoading());
    try {
      final response = await ApiService.slicGetData({
        "filter": {"P_TXN_TYPE": txnType},
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
    try {
      final bodyList = itemCodes
          .map((e) => <String, Object>{
                "Item-Code": e.itemCode.toString(),
                "Size": "${e.productSize}",
                "Qty": "${e.itemQty}",
                "UserID": "${SharedStorage.getEmail()}"
              })
          .toList();

      final body = {
        "_keyword_": "Production",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          <String, Object>{
            "Company": "SLIC",
            // "UserId": "SYSADMIN",
            "TransactionCode": transactionCode.toString(),
            "LocationCode": fromLocationCode.toString(),
            "UserID": "${SharedStorage.getEmail()}",
            "ProductionDate": date.text.trim().toString(),
            "item": bodyList
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "${SharedStorage.getEmail()}",
        "APICODE": "PRODUCTIONWO",
        "LANG": "ENG"
      };

      log(niceJson(body));

      final response =
          await ApiService.slicPostData(body) as Map<String, dynamic>;

      if (bool.parse(response['success'])) {
        emit(GoodsIssuePostSuccess(
          message: niceJson(response),
        ));
      } else {
        if (response.containsKey("message") && response.containsKey("error")) {
          emit(GoodsIssuePostError(
              errorMessage: "${response['message']} ${response['error']}"));
        } else if (response.containsKey("message")) {
          emit(GoodsIssuePostError(errorMessage: response['message']));
        } else if (response.containsKey("MESSAGE")) {
          emit(GoodsIssuePostError(errorMessage: response['MESSAGE']));
        }
      }
    } catch (e) {
      log(e.toString());
      emit(GoodsIssuePostError(errorMessage: e.toString()));
    }
  }
}
