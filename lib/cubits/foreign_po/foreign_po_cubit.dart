import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/api_response.dart';
import 'package:slic/models/tblPOFPOMaster.dart';
import 'package:slic/services/api_service.dart';

part 'foreign_po_states.dart';

class ForeignPoCubit extends Cubit<ForeignPoState> {
  ForeignPoCubit() : super(ForeignPoInitial());

  static ForeignPoCubit get(context) => BlocProvider.of(context);

  int page = 0;
  int limit = 10;

  List<POFPOMaster> models = [];

  void getPaginatedForeignPo() async {
    emit(ForeignPoGetLoading());
    try {
      page++;
      final response = await ApiService.getPaginatedforeignPO(page, limit);
      if (response.success) {
        emit(ForeignPoGetSuccess(response.data));
      } else {
        page--;
        emit(ForeignPoGetError(response.message));
      }
    } catch (error) {
      page--;
      emit(ForeignPoGetError(error.toString()));
    }
  }

  void getAllForeignPo() async {
    emit(ForeignPoGetLoading());
    final response = await ApiService.getAllforeignPO();
    if (response.success) {
      emit(ForeignPoGetSuccess(response));
    } else {
      emit(ForeignPoGetError(response.message));
    }
  }
}
