import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/sales_order_model.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/models/so_line_item_model.dart';
import 'package:slic/services/api_service.dart';
import 'package:slic/utils/shared_storage.dart';

part 'line_item_states.dart';

class LineItemCubit extends Cubit<LineItemState> {
  LineItemCubit() : super(LineItemInitial());

  static LineItemCubit get(context) => BlocProvider.of(context);

  List<LineItem> lineItems = [];
  Map<String, List<PoLineItemModel>> poLineItemsMap = {};
  Map<String, List<SoLineItemModel>> soLineItemsMap = {};
  List<PoLineItemModel> poLineItems = [];
  List<SoLineItemModel> soLineItems = [];
  List<SoLineItemModel> selectedSOLineItems = [];
  String? selectedSysId;
  final List counter = [];

  void slicPOLineItemsById(String sysId) async {
    emit(LineItemGetBySysIdLoading());
    try {
      // if list for specific head sys id exists, then dont call the API, otherwise call it
      if (poLineItemsMap.containsKey(sysId)) {
        poLineItems = poLineItemsMap[sysId]!;
        emit(LineItemGetBySysIdSuccess());
        return;
      }
      poLineItems = await ApiService.getPoLineItems(sysId);
      poLineItemsMap[sysId] = poLineItems;
      emit(LineItemGetBySysIdSuccess());
    } catch (err) {
      emit(LineItemGetBySysIdError(err.toString()));
    }
  }

  void slicSOLineItemsById(String sysId) async {
    emit(LineItemGetBySysIdLoading());
    try {
      // if list for specific head sys id exists, then dont call the API, otherwise call it
      if (soLineItemsMap.containsKey(sysId)) {
        soLineItems = soLineItemsMap[sysId]!;
        emit(LineItemGetBySysIdSuccess());
        return;
      }
      soLineItems = await ApiService.getSoLineItems(sysId);
      soLineItemsMap[sysId] = soLineItems;
      emit(LineItemGetBySysIdSuccess());
    } catch (err) {
      emit(LineItemGetBySysIdError(err.toString()));
    }
  }

  void updateSlicLineItem(PoLineItemModel lineItem) async {
    final itemList = poLineItemsMap["$selectedSysId"];
    if (itemList != null) {
      final index = itemList.indexWhere((element) =>
          element.listOfPOItem?.iTEMSYSID == lineItem.listOfPOItem?.iTEMSYSID);
      if (index != -1) {
        itemList[index] = lineItem;
      } else {
        itemList.add(lineItem);
      }
    }

    // if item sys id does not exist in the list
    if (!counter.contains(lineItem.listOfPOItem?.iTEMSYSID)) {
      counter.add(lineItem.listOfPOItem?.iTEMSYSID);
    }
    emit(LineItemGetBySysIdSuccess());
  }

  void updateSOSlicLineItem(SoLineItemModel lineItem) async {
    final itemList = soLineItemsMap["$selectedSysId"];
    if (itemList != null) {
      final index = itemList.indexWhere((element) =>
          element.listOfSOItem?.iTEMSYSID == lineItem.listOfSOItem?.iTEMSYSID);
      if (index != -1) {
        itemList[index] = lineItem;
      } else {
        itemList.add(lineItem);
      }
    }

    // if item sys id does not exist in the list
    if (!counter.contains(lineItem.listOfSOItem?.iTEMSYSID)) {
      counter.add(lineItem.listOfSOItem?.iTEMSYSID);
    }
    emit(LineItemGetBySysIdSuccess());
  }

  void getLineItemsBySysId(String sysId) async {
    emit(LineItemGetBySysIdLoading());
    try {
      final res = await ApiService.getLineItems(sysId);
      if (res.success) {
        lineItems = res.data;
        emit(LineItemGetBySysIdSuccess());
      } else {
        emit(LineItemGetBySysIdError(res.message));
      }
    } catch (err) {
      emit(LineItemGetBySysIdError(err.toString()));
    }
  }

  void getLineItemsBySysIds(sysIds) async {
    emit(LineItemGetBySysIdsLoading());
    try {
      final res = await ApiService.getLineItemsBySysIds(sysIds);
      if (res.success) {
        lineItems = res.data;
        emit(LineItemGetBySysIdsSuccess());
      } else {
        emit(LineItemGetBySysIdsError(res.message));
      }
    } catch (err) {
      emit(LineItemGetBySysIdsError(err.toString()));
    }
  }

  void poToGRN(locationCode, {required List<SlicPOModel> selectedPOs}) async {
    emit(LineItemPOToGRNLoading());
    try {
      final itemList = selectedPOs
          .map(
            (po) => <String, Object>{
              "SessionId": DateTime.now().toIso8601String(),
              "Company": "SLIC",
              "HeadSysId": po.listOfPO!.hEADSYSID.toString(),
              "TransactionCode": "FPO",
              "TransactionNo": "2017000002",
              "LocationCode": locationCode.toString(),
              "SystemId": "SYSADMIN",
              "Item": poLineItemsMap.isEmpty
                  ? []
                  : poLineItemsMap[po.listOfPO?.hEADSYSID] == null
                      ? []
                      : poLineItemsMap[po.listOfPO?.hEADSYSID]!
                          .map(
                            (lineItem) => {
                              "SessionId": DateTime.now().toIso8601String(),
                              "HeadSysId": po.listOfPO?.hEADSYSID.toString(),
                              "ItemSysId":
                                  lineItem.listOfPOItem?.iTEMSYSID.toString(),
                              "Item-Code": lineItem.listOfPOItem?.iTEMCODE
                                  .toString(), // Key with hyphen
                              "ItemDescription":
                                  lineItem.listOfPOItem?.iTEMNAME.toString(),
                              "Size": lineItem.listOfPOItem?.gRADE.toString(),
                              "UnitCode": lineItem.listOfPOItem?.uOM.toString(),
                              "ReceivedQty":
                                  lineItem.listOfPOItem?.rECEIVEDQTY.toString(),
                              "SystemId": "SYSADMIN"
                            },
                          )
                          .toList(),
            },
          )
          .toList();

      final body = {
        "keyword": "purchaseorder",
        "secret-key": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": itemList,
        "COMPANY": "SLIC",
        "USERID": "${SharedStorage.getEmail()}",
        "APICODE": "POTOGRN",
        "LANG": "ENG"
      };

      log(jsonEncode(body));

      final res = await ApiService.slicPostData(body) as Map;

      if (res.containsKey("error")) {
        emit(LineItemPOToGRNError(res['error'].toString()));
      } else if (res.containsKey("MESSAGE") && res.containsKey("GRN_DOC_NO")) {
        emit(LineItemPOToGRNSuccess(
          res["MESSAGE"],
          res["GRN_SYS_ID"],
          res["GRN_DOC_NO"],
        ));
      } else {
        emit(LineItemPOToGRNError(res['error'].toString()));
      }
    } catch (error) {
      emit(LineItemPOToGRNError(error.toString()));
    }
  }

  void soToGRN(
    locationCode, {
    required List<SalesOrderModel> selectedSOs,
    String? paymentMode,
    String? taxReason,
  }) async {
    emit(LineItemSOToGRNLoading());
    try {
      final itemList = selectedSOs
          .map(
            (so) => <String, Object>{
              "SessionId": DateTime.now().toIso8601String(),
              "Company": "SLIC",
              "HeadSysId": so.listOfSO!.hEADSYSID.toString(),
              "TransactionCode": "${so.listOfSO?.sONUMBER?.split('-')[0]}",
              "TransactionNo": "${so.listOfSO?.sONUMBER?.split('-')[1]}",
              "LocationCode": locationCode.toString(),
              "SystemId": "SYSADMIN",
              "ZATCAPaymentMode": "$paymentMode",
              "TaxExemptionReason": "$taxReason",
              "Item": soLineItemsMap.isEmpty
                  ? []
                  : soLineItemsMap[so.listOfSO?.hEADSYSID.toString()] == null
                      ? []
                      : soLineItemsMap[so.listOfSO?.hEADSYSID.toString()]!
                          .map(
                            (lineItem) => {
                              "SessionId": DateTime.now().toIso8601String(),
                              "HeadSysId": so.listOfSO?.hEADSYSID.toString(),
                              "ItemSysId":
                                  lineItem.listOfSOItem?.iTEMSYSID.toString(),
                              "Item-Code": lineItem.listOfSOItem?.iTEMCODE
                                  .toString(), // Key with hyphen
                              "ItemDescription":
                                  lineItem.listOfSOItem?.iTEMNAME.toString(),
                              "Size": lineItem.listOfSOItem?.gRADE.toString(),
                              "UnitCode": lineItem.listOfSOItem?.uOM.toString(),
                              "ReceivedQty":
                                  lineItem.listOfSOItem?.iNVQTY.toString(),
                              "SystemId": "SYSADMIN"
                            },
                          )
                          .toList(),
            },
          )
          .toList();

      final body = {
        "_keyword_": "SOToInvoice",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": itemList,
        "COMPANY": "SLIC",
        "USERID": "${SharedStorage.getEmail()}",
        "APICODE": "SOTOINV",
        "LANG": "ENG"
      };

      log(jsonEncode(body));

      final res = await ApiService.slicPostData(body) as Map;

      if (res.containsKey("error")) {
        emit(LineItemSOToGRNError(res['error'].toString()));
      } else if (res.containsKey("MESSAGE") && res.containsKey("GRN_DOC_NO")) {
        emit(LineItemSOToGRNSuccess(
          res["MESSAGE"],
          res["GRN_SYS_ID"],
          res["GRN_DOC_NO"],
        ));
      } else {
        emit(LineItemSOToGRNError(res['error'].toString()));
      }
    } catch (error) {
      emit(LineItemSOToGRNError(error.toString()));
    }
  }

  clearAll() {
    lineItems.clear();
    poLineItemsMap.clear();
    soLineItemsMap.clear();
    poLineItems.clear();
    soLineItems.clear();
    selectedSysId = null;
    counter.clear();
    emit(LineItemInitial());
  }
}
