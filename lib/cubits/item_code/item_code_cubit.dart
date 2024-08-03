import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/services/api_service.dart';

part 'item_code_states.dart';

class ItemCodeCubit extends Cubit<ItemCodeState> {
  ItemCodeCubit() : super(ItemCodeInitial());

  static ItemCodeCubit get(context) => BlocProvider.of(context);

  List<ItemCode> itemCodes = [];
  String? gtin;

  void getItemCodeByGtin() async {
    emit(ItemCodeLoading());
    try {
      final res = await ApiService.getItemCodesByGtin(gtin.toString());
      if (res.success) {
        itemCodes.add(res.data);
        emit(ItemCodeSuccess());
      } else {
        emit(ItemCodeError(res.message));
      }
    } catch (error) {
      print(error);
      emit(ItemCodeError(error.toString()));
    }
  }

  void dispose() {
    itemCodes.clear();
    gtin = null;
  }
}
