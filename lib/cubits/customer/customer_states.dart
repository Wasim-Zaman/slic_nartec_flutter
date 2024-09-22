part of "customer_cubit.dart";

abstract class CustomerState {}

final class CustomerInitial extends CustomerState {}

// ? Loading
final class CustomerSaveQuotationLoading extends CustomerState {}

final class CustomerSaveOrderLoading extends CustomerState {}

// * Success
final class CustomerSaveQuotationSuccess extends CustomerState {
  final String message, refNo, docNo;

  CustomerSaveQuotationSuccess({
    required this.message,
    required this.refNo,
    required this.docNo,
  });
}

final class CustomerSaveOrderSuccess extends CustomerState {
  final String message;

  CustomerSaveOrderSuccess({required this.message});
}

final class CustomerDateChanged extends CustomerState {}

// ! Error
final class CustomerSaveQuotationError extends CustomerState {
  final String message;

  CustomerSaveQuotationError({required this.message});
}

final class CustomerSaveOrderError extends CustomerState {
  final String message;

  CustomerSaveOrderError({required this.message});
}
