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

  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      // If the search query is empty, restore the original data
      emit(ForeignPoSearchSuccess(models));
    } else {
      // Filter the list based on the query
      var filteredData = models.where((po) {
        return po.pONumber!.toLowerCase().contains(query.toLowerCase()) ||
            po.supplierName!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Emit the filtered data as a new state
      emit(ForeignPoSearchSuccess(filteredData));
    }
  }

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
