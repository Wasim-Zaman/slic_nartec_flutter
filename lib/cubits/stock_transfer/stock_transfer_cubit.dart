import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/services/api_service.dart';

part 'stock_transfer_states.dart';

class StockTransferCubit extends Cubit<StockTransferState> {
  StockTransferCubit() : super(StockTransferInitial());

  static StockTransferCubit get(context) => BlocProvider.of(context);

  // Variables
  List<ItemCode> itemCodes = [];
  String? gtin;
  String? transaction;
  String? fromLocation;
  String? toLocation;
  int boxQuantity = 1;
  String size = "37";
  String type = "U";
  double total = 0;

  void dispose() {
    itemCodes.clear();
    gtin = null;
    transaction = null;
    fromLocation = null;
    toLocation = null;
    boxQuantity = 1;
    size = "37";
    type = "U";
    total = 0;
  }

  void transferStock() async {
    emit(StockTransferPostLoading());
    try {
      // * API Call
      final response = await ApiService.slicPostData({
        "_keyword_": "LTO",
        "_secret-key_": "2bf52be7-9f68-4d52-9523-53f7f267153b",
        "data": [
          {
            "Company": "SLIC",
            "TransactionCode": "LDTO",
            "FromLocation-Code": "FG101",
            "ToLocation-Code": "FG102",
            "UserId": "SYSADMIN",
            "Item": [
              {
                "ItemCode": "4415",
                "Size": "37",
                "Qty": "10",
                "UserId": "SYSADMIN"
              }
            ]
          }
        ],
        "COMPANY": "SLIC",
        "USERID": "SYSADMIN",
        "APICODE": "STOCKTRANSFER",
        "LANG": "ENG"
      });
      emit(StockTransferPostSuccess());
    } catch (e) {
      emit(StockTransferPostError());
    }
  }
}
