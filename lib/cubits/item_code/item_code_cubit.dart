import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/item_rate.dart';
import 'package:slic/services/api_service.dart';

part 'item_code_states.dart';

class ItemCodeCubit extends Cubit<ItemCodeState> {
  ItemCodeCubit() : super(ItemCodeInitial());

  static ItemCodeCubit get(context) => BlocProvider.of(context);

  List<ItemCode> itemCodes = [];
  String? gtin;
  ItemRate? itemRate;

  void getItemCodeByGtin({required int qty, required int size}) async {
    emit(ItemCodeLoading());
    try {
      final res = await ApiService.getItemCodesByGtin(gtin.toString());
      if (res.success) {
        ItemCode itemCode = res.data;
        itemCode.itemQty = qty;
        itemCode.size = size;
        // itemCode.size = int.tryParse(itemCode.productSize.toString()) ?? 0;

        itemCodes.add(itemCode);
        emit(ItemCodeSuccess(itemCode: itemCode));
      } else {
        emit(ItemCodeError(res.message));
      }
    } catch (error) {
      emit(ItemCodeError(error.toString()));
    }
  }

  getItemRate(itemCode, custCode, productSize) async {
    try {
      final body = {
        "filter": {
          "P_COMP_CODE": "SLIC",
          "P_ITEM_CODE": "$productSize",
          "P_CUST_CODE": "$custCode",
          "P_GRADE_CODE_1": "$productSize"
        },
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "PRICELIST",
        "M_LANG_CODE": "ENG"
      };

      log(jsonEncode(body));

      final response = await ApiService.slicGetData(body);

      if (response.length != 0) {
        itemRate = response[0];
        itemCodes
                .firstWhere(
                  (element) =>
                      element.itemCode == itemCode &&
                      element.productSize == productSize,
                )
                .rate =
            itemRate?.pRICELIST?.pLIRATE == null
                ? "0"
                : "${itemRate?.pRICELIST?.pLIRATE}";

        print("${itemRate?.pRICELIST?.pLIRATE}");

        emit(ItemCodeSuccess(rate: itemRate));
      } else {
        itemCodes
            .firstWhere(
              (element) =>
                  element.itemCode == itemCode &&
                  element.productSize == productSize,
            )
            .rate = "0";
        emit(ItemCodeError("No rate found."));
      }
    } catch (error) {
      print(error);
    }
  }

  void dispose() {
    itemCodes.clear();
    gtin = null;
  }
}
