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
  String? itemCode;
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

  void getItemCodeByItemCode({required int qty, required int size}) async {
    emit(ItemCodeLoading());
    try {
      final res = await ApiService.getItemCodesByItemCode(itemCode.toString());
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

  Future<void> getItemRate(
      String itemCode, String custCode, String productSize) async {
    try {
      // Construct the request body
      final Map<String, dynamic> body = {
        "filter": {
          "P_COMP_CODE": "SLIC",
          "P_ITEM_CODE": itemCode,
          "P_CUST_CODE": custCode,
          "P_GRADE_CODE_1": productSize
        },
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "PRICELIST",
        "M_LANG_CODE": "ENG"
      };

      // Log the request body for debugging purposes
      log(jsonEncode(body));

      // Fetch response from the API
      final response = await ApiService.slicGetData(body) as List<dynamic>;

      if (response.isEmpty) {
        _updateItemRate(itemCode, productSize, "0");
        emit(ItemCodeRateError("No rate found."));
        return;
      }

      // Parse the response and extract item rates
      final List<ItemRate> itemRates =
          response.map((json) => ItemRate.fromJson(json)).toList();

      // Update item rate
      final itemRate = itemRates.first;
      final rate = itemRate.pRICELIST?.pLIRATE?.toString() ?? "0";
      _updateItemRate(itemCode, productSize, rate);

      // Emit success event with the item rate
      emit(ItemCodeRateSuccess(rate: itemRate));
    } catch (error, stacktrace) {
      log("Error fetching item rate: $error\n$stacktrace");
      emit(ItemCodeRateError("Failed to fetch item rate."));
    }
  }

// Helper function to update the rate of the item
  void _updateItemRate(String itemCode, String productSize, String rate) {
    final item = itemCodes.firstWhere(
      (element) =>
          element.itemCode == itemCode && element.productSize == productSize,
      orElse: () => ItemCode(),
    );

    item.rate = rate;
    log("Updated rate for itemCode: $itemCode, productSize: $productSize to $rate");
  }

  void dispose() {
    itemCodes.clear();
    gtin = null;
  }
}
