import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/pos_invoice_model.dart';
import 'package:slic/models/transaction_code_model.dart';
import 'package:slic/services/api_service.dart';

part 'sales_return_states.dart';

class SalesReturnCubit extends Cubit<SalesReturnState> {
  SalesReturnCubit() : super(SalesReturnInitial());

  static SalesReturnCubit get(context) =>
      BlocProvider.of<SalesReturnCubit>(context);

  // Lists
  List<TransactionCodeModel> transactionCodes = [];
  List<POSInvoiceModel> invoices = [];

  // Selected values
  String? transactionName;
  String? transactionCode;
  String? invoiceNumber;
  num? returnQty;

  void getPOSInvoice() async {
    emit(SalesReturnPOSInvoiceLoading());
    try {
      final response = await ApiService.getPOSDetailsByInvoice(
        invoiceNumber,
        transactionCode,
      );

      if (response.success) {
        invoices = response.data;
        emit(SalesReturnPOSInvoiceSuccess());
      } else {
        emit(SalesReturnPOSInvoiceError(errorMessage: response.message));
      }
    } catch (error) {
      emit(SalesReturnPOSInvoiceError(errorMessage: error.toString()));
    }
  }

  getTransactionCodes() async {
    emit(SalesReturnTransactionCodesLoading());
    try {
      final response = await ApiService.slicGetData({
        "filter": {"P_TXN_TYPE": "LTRFO"},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ListOfTransactionCode",
        "M_LANG_CODE": "ENG"
      });

      response.forEach((element) {
        transactionCodes.add(TransactionCodeModel.fromJson(element));
      });

      emit(SalesReturnTransactionCodesSuccess());
    } catch (error) {
      emit(SalesReturnTransactionCodesError(errorMessage: error.toString()));
    }
  }

  void updateInvoiceTemp(itemSysID, itemCode) async {
    try {
      emit(SalesReturnUpdateTempLoading());
      final response =
          await ApiService.updateInvoiceTemp(itemSysID, itemCode, returnQty);

      if (response.success) {
        emit(SalesReturnUpdateTempSuccess(successMessage: response.message));
      } else {
        emit(SalesReturnUpdateTempError(errorMessage: response.message));
      }
    } catch (error) {
      emit(SalesReturnUpdateTempError(errorMessage: error.toString()));
    }
  }
}
