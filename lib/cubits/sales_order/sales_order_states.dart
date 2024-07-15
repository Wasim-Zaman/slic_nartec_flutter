part of 'sales_order_cubit.dart';

abstract class SalesOrderState {}

final class SalesOrderInitial extends SalesOrderState {}

// Loading
final class SalesOrderGetAllLoading extends SalesOrderState {}

// * Success

final class SalesOrderGetAllSuccess extends SalesOrderState {}

// ! Error

final class SalesOrderGetAllError extends SalesOrderState {
  final String message;

  SalesOrderGetAllError(this.message);
}
