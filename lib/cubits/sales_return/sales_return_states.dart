part of 'sales_return_cubit.dart';

abstract class SalesReturnState {}

final class SalesReturnInitial extends SalesReturnState {}

//? Loading
final class SalesReturnTransactionCodesLoading extends SalesReturnState {}

final class SalesReturnPOSInvoiceLoading extends SalesReturnState {}

final class SalesReturnUpdateTempLoading extends SalesReturnState {}

final class SalesReturnSaveInvoiceLoading extends SalesReturnState {}

//* Success

final class SalesReturnTransactionCodesSuccess extends SalesReturnState {}

final class SalesReturnPOSInvoiceSuccess extends SalesReturnState {}

final class SalesReturnUpdateTempSuccess extends SalesReturnState {
  final String successMessage;
  SalesReturnUpdateTempSuccess({required this.successMessage});
}

final class SalesReturnSaveInvoiceSuccess extends SalesReturnState {
  final String successMessage;
  final String? salesReturnSysId, salesReturnDocNo;
  SalesReturnSaveInvoiceSuccess({
    required this.successMessage,
    this.salesReturnDocNo,
    this.salesReturnSysId,
  });
}

final class SalesReturnChangedItemSysId extends SalesReturnState {}

//! Error

final class SalesReturnTransactionCodesError extends SalesReturnState {
  final String errorMessage;

  SalesReturnTransactionCodesError({required this.errorMessage});
}

final class SalesReturnPOSInvoiceError extends SalesReturnState {
  final String errorMessage;

  SalesReturnPOSInvoiceError({required this.errorMessage});
}

final class SalesReturnUpdateTempError extends SalesReturnState {
  final String errorMessage;

  SalesReturnUpdateTempError({required this.errorMessage});
}

final class SalesReturnSaveInvoiceError extends SalesReturnState {
  final String errorMessage;

  SalesReturnSaveInvoiceError({required this.errorMessage});
}
