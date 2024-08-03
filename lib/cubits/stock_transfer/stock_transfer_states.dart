part of 'stock_transfer_cubit.dart';

abstract class StockTransferState {}

final class StockTransferInitial extends StockTransferState {}

// ? Loading

final class StockTransferPostLoading extends StockTransferState {}

// * Success

final class StockTransferPostSuccess extends StockTransferState {}

// ! Error

final class StockTransferPostError extends StockTransferState {}
