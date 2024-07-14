part of 'foreign_po_cubit.dart';

abstract class ForeignPoState {}

class ForeignPoInitial extends ForeignPoState {}

// Loading

class ForeignPoGetLoading extends ForeignPoState {}

class ForeignPoSearchLoading extends ForeignPoState {}

// * Success

class ForeignPoGetSuccess extends ForeignPoState {
  final ApiResponse res;

  ForeignPoGetSuccess(this.res);
}

class ForeignPoSearchSuccess extends ForeignPoState {
  final List<POFPOMaster> data;

  ForeignPoSearchSuccess(this.data);
}

// ! Error

class ForeignPoGetError extends ForeignPoState {
  final String error;

  ForeignPoGetError(this.error);
}

class ForeignPoSearchError extends ForeignPoState {
  final String error;

  ForeignPoSearchError(this.error);
}
