part of 'foreign_po_cubit.dart';

abstract class ForeignPoState {}

class ForeignPoInitial extends ForeignPoState {}

// Loading

class ForeignPoGetLoading extends ForeignPoState {}

// * Success

class ForeignPoGetSuccess extends ForeignPoState {
  final ApiResponse res;

  ForeignPoGetSuccess(this.res);
}

// ! Error

class ForeignPoGetError extends ForeignPoState {
  final String error;

  ForeignPoGetError(this.error);
}
