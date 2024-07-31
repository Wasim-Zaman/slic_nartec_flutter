import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/services/api_service.dart';

part 'line_item_states.dart';

class LineItemCubit extends Cubit<LineItemState> {
  LineItemCubit() : super(LineItemInitial());

  static LineItemCubit get(context) => BlocProvider.of(context);

  List<LineItem> lineItems = [];
  Map<String, List<SlicLineItemModel>> slicLineItemsMap = {};
  List<SlicLineItemModel> slicLineItems = [];
  String? selectedSysId;
  final List counter = [];

  void slicLineItemsById(String sysId) async {
    emit(LineItemGetBySysIdLoading());
    try {
      // if list for specific head sys id exists, then dont call the API, otherwise call it
      if (slicLineItemsMap.containsKey(sysId)) {
        slicLineItems = slicLineItemsMap[sysId]!;
        emit(LineItemGetBySysIdSuccess());
        return;
      }
      slicLineItems = await ApiService.getPoLineItems(sysId);
      slicLineItemsMap[sysId] = slicLineItems;
      emit(LineItemGetBySysIdSuccess());
    } catch (err) {
      emit(LineItemGetBySysIdError(err.toString()));
    }
  }

  void updateSlicLineItem(SlicLineItemModel lineItem) async {
    // update the line item inside slicLineItemsMap
    // var i = slicLineItemsMap["$selectedSysId"]!.indexWhere((element) {
    //   return element.listOfPOItem?.iTEMSYSID ==
    //       lineItem.listOfPOItem?.iTEMSYSID;
    // });
    // slicLineItemsMap["$selectedSysId"]!.toList()[i] = lineItem;
    slicLineItemsMap["$selectedSysId"]!.removeWhere((element) {
      return element.listOfPOItem?.iTEMSYSID ==
          lineItem.listOfPOItem?.iTEMSYSID;
    });
    slicLineItemsMap["$selectedSysId"]!.add(lineItem);
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

  void poToGRN(locationCode) async {
    emit(LineItemPOToGRNLoading());
    try {
      var body = {
        "_keyword_": "purchaseorder",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          {
            "SessionId": DateTime.now().toIso8601String(),
            "Company": "001",
            "HeadSysId": selectedSysId.toString(),
            "TransactionCode": "FPO",
            "TransactionNo": "2017000002",
            "LocationCode": locationCode.toString(),
            "SystemId": "SYSADMIN",
            "Item": slicLineItems
                .map(
                  (e) => {
                    "SessionId": DateTime.now().toIso8601String(),
                    "HeadSysId": selectedSysId.toString(),
                    "ItemSysId": e.listOfPOItem?.iTEMSYSID,
                    "Item-Code": e.listOfPOItem?.iTEMCODE,
                    "ItemDescription": e.listOfPOItem?.iTEMNAME,
                    "Size": e.listOfPOItem?.gRADE,
                    "UnitCode": e.listOfPOItem?.uOM,
                    "ReceivedQty": e.listOfPOItem?.rECEIVEDQTY,
                    "SystemId": "SYSADMIN"
                  },
                )
                .toList(),
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "SYSADMIN",
        "APICODE": "POTOGRN",
        "LANG": "ENG"
      };

      final res = await ApiService.slicPostData(body);
      emit(LineItemPOToGRNSuccess(res['message']));
    } catch (err) {
      emit(LineItemPOToGRNError(err.toString()));
    }
  }
}
