part of 'line_item_cubit.dart';

abstract class LineItemState {}

class LineItemInitial extends LineItemState {}

// ? Loading

class LineItemGetBySysIdLoading extends LineItemState {}

// * Success

class LineItemGetBySysIdSuccess extends LineItemState {}

// ! Error

class LineItemGetBySysIdError extends LineItemState {
  final String message;

  LineItemGetBySysIdError(this.message);
}
