import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/models/so_line_item_model.dart';
import 'package:slic/services/api_service.dart';

part 'line_item_states.dart';

class LineItemCubit extends Cubit<LineItemState> {
  LineItemCubit() : super(LineItemInitial());

  static LineItemCubit get(context) => BlocProvider.of(context);

  List<LineItem> lineItems = [];
  Map<String, List<PoLineItemModel>> poLineItemsMap = {};
  Map<String, List<SoLineItemModel>> soLineItemsMap = {};
  List<PoLineItemModel> poLineItems = [];
  List<SoLineItemModel> soLineItems = [];
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
    // update the line item inside slicLineItemsMap
    // var i = slicLineItemsMap["$selectedSysId"]!.indexWhere((element) {
    //   return element.listOfPOItem?.iTEMSYSID ==
    //       lineItem.listOfPOItem?.iTEMSYSID;
    // });
    // slicLineItemsMap["$selectedSysId"]!.toList()[i] = lineItem;
    poLineItemsMap["$selectedSysId"]!.removeWhere((element) {
      return element.listOfPOItem?.iTEMSYSID ==
          lineItem.listOfPOItem?.iTEMSYSID;
    });
    poLineItemsMap["$selectedSysId"]!.add(lineItem);
    // if item sys id do not exist in the list
    if (!counter.contains(lineItem.listOfPOItem?.iTEMSYSID)) {
      counter.add(lineItem.listOfPOItem?.iTEMSYSID);
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
      final body = {
        "keyword": "purchaseorder",
        "secret-key": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": selectedPOs
            .map(
              (po) => {
                "SessionId": DateTime.now().toIso8601String(),
                "Company": "SLIC",
                "HeadSysId": po.listOfPO?.hEADSYSID,
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
                                "HeadSysId": po.listOfPO?.hEADSYSID,
                                "ItemSysId": lineItem.listOfPOItem?.iTEMSYSID,
                                "Item-Code": lineItem.listOfPOItem?.iTEMCODE,
                                "ItemDescription":
                                    lineItem.listOfPOItem?.iTEMNAME,
                                "Size": lineItem.listOfPOItem?.gRADE,
                                "UnitCode": lineItem.listOfPOItem?.uOM,
                                "ReceivedQty":
                                    lineItem.listOfPOItem?.rECEIVEDQTY,
                                "SystemId": "SYSADMIN"
                              },
                            )
                            .toList(),
              },
            )
            .toList(),
        "COMPANY": "SLIC",
        "USERID": "SYSADMIN",
        "APICODE": "POTOGRN",
        "LANG": "ENG"
      };

      log(jsonEncode(body));

      final res = await ApiService.slicPostData(body);
      // if message key exists in the response, then emit success state
      if (res.containsKey('message') || res.containsKey('error')) {
        if (res.containsKey('mesage')) {
          emit(LineItemPOToGRNSuccess(res['message'].toString()));
        } else {
          emit(LineItemPOToGRNError(res['error'].toString()));
        }
      } else {
        emit(LineItemPOToGRNError(res.toString()));
      }
    } catch (error) {
      emit(LineItemPOToGRNError(error.toString()));
    }
  }
}
