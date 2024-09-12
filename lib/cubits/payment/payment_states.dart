part of "payment_cubit.dart";

abstract class PaymentState {}

final class PaymentInitial extends PaymentState {}

// ? LOADING
final class PaymentZATCAPaymentLoading extends PaymentState {}

final class PaymentTaxExemptionReasonLoading extends PaymentState {}

// * SUCCESS

final class PaymentZATCAPaymentSuccess extends PaymentState {}

final class PaymentTaxExemptionReasonSuccess extends PaymentState {}

// ! ERROR

final class PaymentZATCAPaymentError extends PaymentState {
  final String errorMessage;

  PaymentZATCAPaymentError({required this.errorMessage});
}

final class PaymentTaxExemptionReasonError extends PaymentState {
  final String errorMessage;

  PaymentTaxExemptionReasonError({required this.errorMessage});
}
