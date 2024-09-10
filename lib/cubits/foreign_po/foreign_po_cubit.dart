import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/api_response.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/models/tblPOFPOMaster.dart';
import 'package:slic/services/api_service.dart';

part 'foreign_po_states.dart';

class ForeignPoCubit extends Cubit<ForeignPoState> {
  ForeignPoCubit() : super(ForeignPoInitial());

  static ForeignPoCubit get(context) => BlocProvider.of(context);

  int page = 0;
  int limit = 10;

  List<POFPOMaster> models = [];
  List<SlicPOModel> slicPOList = [];
  List<SlicPOModel> selectedPOList = [];
  final selectedSysIds = [];

  ItemCode? data;

  // void updateSearchQuery(String query) {
  //   if (query.isEmpty) {
  //     // If the search query is empty, restore the original data
  //     emit(ForeignPoSearchSuccess(models));
  //   } else {
  //     // Filter the list based on the query
  //     var filteredData = models.where((po) {
  //       return po.pONumber!.toLowerCase().contains(query.toLowerCase()) ||
  //           po.supplierName!.toLowerCase().contains(query.toLowerCase());
  //     }).toList();

  //     // Emit the filtered data as a new state
  //     emit(ForeignPoSearchSuccess(filteredData));
  //   }
  // }
  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      // If the search query is empty, restore the original data
      emit(ForeignPoGetSlicPOListSuccess(slicPOList));
    } else {
      // Filter the list based on the query
      var filteredData = slicPOList.where((po) {
        return po.listOfPO!.sUPPNAME!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            po.listOfPO!.hEADSYSID!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            po.listOfPO!.dOCDT!.toLowerCase().contains(query.toLowerCase()) ||
            po.listOfPO!.dOCNO!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Emit the filtered data as a new state
      emit(ForeignPoGetSlicPOListSuccess(filteredData));
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

  void getSlicPoList() async {
    emit(ForiegnPoGetSlicPOListLoading());
    try {
      slicPOList = await ApiService.getPoList();
      emit(ForeignPoGetSlicPOListSuccess(slicPOList));
    } catch (err) {
      emit(ForeignPiGetSlicPOListError(err.toString()));
    }
  }

  void getItemCodeByItemSKU(itemSKU) async {
    try {
      emit(ForeignPoGetItemCodeByItemSKULoading());
      final response = await ApiService.getItemCodeByItemCode(itemSKU);

      if (response.success) {
        data = response.data;
        emit(ForeignPoGetItemCodeByItemSKUSuccess(response.data));
      } else {
        emit(ForeignPoGetItemCodeByItemSKUError(response.message));
      }
    } catch (error) {
      emit(ForeignPoGetItemCodeByItemSKUError(error.toString()));
    }
  }

  clearAll() {
    // slicPOList.clear();
    selectedPOList.clear();
    selectedSysIds.clear();
    data = null;
    // emit(ForeignPoInitial());
  }
}
