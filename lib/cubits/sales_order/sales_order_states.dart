part of 'sales_order_cubit.dart';

abstract class SalesOrderState {}

final class SalesOrderInitial extends SalesOrderState {}

// Loading
final class SalesOrderGetAllLoading extends SalesOrderState {}

final class SalesOrderSlicSOLoading extends SalesOrderState {}

// * Success

final class SalesOrderGetAllSuccess extends SalesOrderState {}

final class SalesOrderGetAllFilteredSuccess extends SalesOrderState {}

final class SalesOrderSlicSOSuccess extends SalesOrderState {}

// ! Error

final class SalesOrderGetAllError extends SalesOrderState {
  final String message;

  SalesOrderGetAllError(this.message);
}

final class SalesOrderSlicSOError extends SalesOrderState {
  final String message;
  SalesOrderSlicSOError(this.message);
}
