import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/sales_order.dart';
import 'package:slic/services/api_service.dart';

part 'sales_order_states.dart';

class SalesOrderCubit extends Cubit<SalesOrderState> {
  SalesOrderCubit() : super(SalesOrderInitial());

  static SalesOrderCubit get(context) => BlocProvider.of(context);

  List<SalesOrder> salesOrderList = [];
  List<SalesOrder> filteredSalesOrders = [];

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
      filteredSalesOrders = List.from(salesOrderList);
    } else {
      filteredSalesOrders = salesOrderList.where((order) {
        if (order.sONUMBER == null ||
            order.sOCUSTNAME == null ||
            order.sOLOCNCODE == null ||
            order.dELLOCN == null ||
            order.sTATUS == null) {
          return false;
        }

        return order.sONUMBER!.toLowerCase().contains(query.toLowerCase()) ||
            order.sOCUSTNAME!.toLowerCase().contains(query.toLowerCase()) ||
            order.sOLOCNCODE!.toLowerCase().contains(query.toLowerCase()) ||
            order.dELLOCN!.toLowerCase().contains(query.toLowerCase()) ||
            order.sTATUS!.toLowerCase().contains(query.toLowerCase()) ||
            order.hEADSYSID.toString().contains(query.toString());
      }).toList();
    }
    emit(SalesOrderGetAllSuccess());
  }
}
