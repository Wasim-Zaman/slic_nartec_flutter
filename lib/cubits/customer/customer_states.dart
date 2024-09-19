part of "customer_cubit.dart";

abstract class CustomerState {}

final class CustomerInitial extends CustomerState {}

// ? Loading
final class CustomerSaveQuotationLoading extends CustomerState {}

// * Success
final class CustomerSaveQuotationSuccess extends CustomerState {
  final String message, refNo, docNo;

  CustomerSaveQuotationSuccess({
    required this.message,
    required this.refNo,
    required this.docNo,
  });
}

// ! Error
final class CustomerSaveQuotationError extends CustomerState {
  final String message;

  CustomerSaveQuotationError({required this.message});
}
