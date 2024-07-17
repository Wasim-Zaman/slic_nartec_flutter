part of 'line_item_cubit.dart';

abstract class LineItemState {}

class LineItemInitial extends LineItemState {}

// ? Loading

class LineItemGetBySysIdLoading extends LineItemState {}
class LineItemGetBySysIdsLoading extends LineItemState {}

// * Success

class LineItemGetBySysIdSuccess extends LineItemState {}
class LineItemGetBySysIdsSuccess extends LineItemState {}

// ! Error

class LineItemGetBySysIdError extends LineItemState {
  final String message;

  LineItemGetBySysIdError(this.message);
}
class LineItemGetBySysIdsError extends LineItemState {
  final String message;

  LineItemGetBySysIdsError(this.message);
}
