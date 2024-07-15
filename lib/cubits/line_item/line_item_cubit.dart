import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/services/api_service.dart';

part 'line_item_states.dart';

class LineItemCubit extends Cubit<LineItemState> {
  LineItemCubit() : super(LineItemInitial());

  static LineItemCubit get(context) => BlocProvider.of(context);

  List<LineItem> lineItems = [];

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
}
