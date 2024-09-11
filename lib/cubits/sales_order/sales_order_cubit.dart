import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/sales_order.dart';
import 'package:slic/models/sales_order_model.dart';
import 'package:slic/services/api_service.dart';

part 'sales_order_states.dart';

class SalesOrderCubit extends Cubit<SalesOrderState> {
  SalesOrderCubit() : super(SalesOrderInitial());

  static SalesOrderCubit get(context) => BlocProvider.of(context);

  List<SalesOrder> salesOrderList = [];
  List<SalesOrder> filteredSalesOrders = [];
  List<SalesOrderModel> salesOrders = [];
  List<SalesOrderModel> selectedSalesOrder = [];
  List<SalesOrderModel> filterSalesOrders = [];
  List<int?> selectedSysId = [];

  void getAllSalesOrder() async {
    emit(SalesOrderGetAllLoading());
    try {
      final res = await ApiService.getSalesOrder();
      salesOrderList = res.data;
      filteredSalesOrders = res.data;
      emit(SalesOrderGetAllSuccess());
    } catch (e) {
      emit(SalesOrderGetAllError(e.toString()));
    }
  }

  // Call this method whenever the search input changes
  void updateSearchQuery(String query) {
    emit(SalesOrderGetAllLoading());
    if (query.isEmpty) {
      filterSalesOrders = List.from(salesOrders);
    } else {
      filterSalesOrders = salesOrders.where((order) {
        if (order.listOfSO?.dELLOCN == null ||
            order.listOfSO?.hEADSYSID == null ||
            order.listOfSO?.sOCUSTNAME == null ||
            order.listOfSO?.sOLOCNCODE == null ||
            order.listOfSO?.sONUMBER == null) {
          return false;
        }

        return order.listOfSO!.dELLOCN!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            order.listOfSO!.hEADSYSID!
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            order.listOfSO!.sOCUSTNAME!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            order.listOfSO!.sOLOCNCODE!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            order.listOfSO!.sONUMBER!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            order.listOfSO!.sONUMBER.toString().contains(query.toString());
      }).toList();
    }

    emit(SalesOrderGetAllFilteredSuccess());
  }

  void getSlicSalesOrder(String locCode) async {
    try {
      emit(SalesOrderSlicSOLoading());

      final body = {
        "filter": {"P_SOH_DEL_LOCN_CODE": locCode},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ListOfSO",
        "M_LANG_CODE": "ENG"
      };

      final res = await ApiService.slicGetData(body);
      res.forEach((so) => salesOrders.add(SalesOrderModel.fromJson(so)));
      if (salesOrders.isEmpty) {
        emit(SalesOrderSlicSOError(
            'No sales orders found for Loc Code "$locCode"'));
      } else {
        emit(SalesOrderSlicSOSuccess());
      }
    } catch (error) {
      emit(SalesOrderSlicSOError(error.toString()));
    }
  }
}
