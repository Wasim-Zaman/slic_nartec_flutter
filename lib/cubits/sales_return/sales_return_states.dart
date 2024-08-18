part of 'sales_return_cubit.dart';

abstract class SalesReturnState {}

final class SalesReturnInitial extends SalesReturnState {}

//? Loading
final class SalesReturnTransactionCodesLoading extends SalesReturnState {}

//* Success

final class SalesReturnTransactionCodesSuccess extends SalesReturnState {}

//! Error

final class SalesReturnTransactionCodesError extends SalesReturnState {
  final String errorMessage;

  SalesReturnTransactionCodesError({required this.errorMessage});
}
