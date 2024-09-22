part of 'item_code_cubit.dart';

abstract class ItemCodeState {}

final class ItemCodeInitial extends ItemCodeState {}

// ? Loading

final class ItemCodeLoading extends ItemCodeState {}

// * Success

final class ItemCodeSuccess extends ItemCodeState {
  final ItemCode? itemCode;
  final ItemRate? rate;
  ItemCodeSuccess({this.rate, this.itemCode});
}

final class ItemCodeRateSuccess extends ItemCodeState {
  final ItemRate? rate;
  ItemCodeRateSuccess({this.rate});
}

// ! Error

final class ItemCodeError extends ItemCodeState {
  final String error;
  ItemCodeError(this.error);
}

final class ItemCodeRateError extends ItemCodeState {
  final String error;
  ItemCodeRateError(this.error);
}
