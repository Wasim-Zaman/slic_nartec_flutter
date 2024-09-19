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

// ! Error

final class ItemCodeError extends ItemCodeState {
  final String error;
  ItemCodeError(this.error);
}
