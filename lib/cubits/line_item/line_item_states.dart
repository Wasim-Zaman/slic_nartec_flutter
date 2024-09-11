part of 'line_item_cubit.dart';

abstract class LineItemState {}

class LineItemInitial extends LineItemState {}

// ? Loading

class LineItemGetBySysIdLoading extends LineItemState {}

class LineItemGetBySysIdsLoading extends LineItemState {}

class LineItemPOToGRNLoading extends LineItemState {}

class LineItemSOToGRNLoading extends LineItemState {}

// * Success

class LineItemGetBySysIdSuccess extends LineItemState {}

class LineItemGetBySysIdsSuccess extends LineItemState {}

class LineItemPOToGRNSuccess extends LineItemState {
  final String message;
  final String? grnSysId, grnDocNo;

  LineItemPOToGRNSuccess(this.message, this.grnSysId, this.grnDocNo);
}

class LineItemSOToGRNSuccess extends LineItemState {
  final String message;
  final String? grnSysId, grnDocNo;

  LineItemSOToGRNSuccess(this.message, this.grnSysId, this.grnDocNo);
}

// ! Error

class LineItemGetBySysIdError extends LineItemState {
  final String message;

  LineItemGetBySysIdError(this.message);
}

class LineItemGetBySysIdsError extends LineItemState {
  final String message;

  LineItemGetBySysIdsError(this.message);
}

class LineItemPOToGRNError extends LineItemState {
  final String message;

  LineItemPOToGRNError(this.message);
}

class LineItemSOToGRNError extends LineItemState {
  final String message;

  LineItemSOToGRNError(this.message);
}
