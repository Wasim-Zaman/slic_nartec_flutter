import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/services/api_service.dart';

part 'item_code_states.dart';

class ItemCodeCubit extends Cubit<ItemCodeState> {
  ItemCodeCubit() : super(ItemCodeInitial());

  static ItemCodeCubit get(context) => BlocProvider.of(context);

  List<ItemCode> itemCodes = [];
  String? gtin;

  void getItemCodeByGtin({required int qty, required int size}) async {
    emit(ItemCodeLoading());
    try {
      final res = await ApiService.getItemCodesByGtin(gtin.toString());
      if (res.success) {
        ItemCode itemCode = res.data;
        itemCode.itemQty = qty;
        itemCode.size = size;

        itemCodes.add(itemCode);
        emit(ItemCodeSuccess());
      } else {
        emit(ItemCodeError(res.message));
      }
    } catch (error) {
      emit(ItemCodeError(error.toString()));
    }
  }

  void dispose() {
    itemCodes.clear();
    gtin = null;
  }
}
