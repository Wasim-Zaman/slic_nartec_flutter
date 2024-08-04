part of 'stock_transfer_cubit.dart';

abstract class StockTransferState {}

final class StockTransferInitial extends StockTransferState {}

// ? Loading

final class StockTransferPostLoading extends StockTransferState {}

final class StockTransferTransactionCodesLoading extends StockTransferState {}

// * Success

final class StockTransferPostSuccess extends StockTransferState {}

final class StockTransferTransactionCodesSuccess extends StockTransferState {}

// ! Error

final class StockTransferPostError extends StockTransferState {
  final String errorMessage;
  StockTransferPostError({required this.errorMessage});
}

final class StockTransferTransactionCodesError extends StockTransferState {
  final String errorMessage;
  StockTransferTransactionCodesError({required this.errorMessage});
}
