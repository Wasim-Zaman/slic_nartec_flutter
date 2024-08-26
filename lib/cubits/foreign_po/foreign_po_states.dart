part of 'foreign_po_cubit.dart';

abstract class ForeignPoState {}

class ForeignPoInitial extends ForeignPoState {}

// Loading

class ForeignPoGetLoading extends ForeignPoState {}

class ForeignPoSearchLoading extends ForeignPoState {}

class ForiegnPoGetSlicPOListLoading extends ForeignPoState {}

final class ForeignPoGetItemCodeByItemSKULoading extends ForeignPoState {}

// * Success

class ForeignPoGetSuccess extends ForeignPoState {
  final ApiResponse res;

  ForeignPoGetSuccess(this.res);
}

class ForeignPoSearchSuccess extends ForeignPoState {
  final List<POFPOMaster> data;

  ForeignPoSearchSuccess(this.data);
}

class ForeignPoSlicPoSearchSuccess extends ForeignPoState {
  final List<SlicPOModel> data;

  ForeignPoSlicPoSearchSuccess(this.data);
}

class ForeignPoGetSlicPOListSuccess extends ForeignPoState {
  final List<SlicPOModel> data;

  ForeignPoGetSlicPOListSuccess(this.data);
}

class ForeignPoGetItemCodeByItemSKUSuccess extends ForeignPoState {
  final ItemCode data;

  ForeignPoGetItemCodeByItemSKUSuccess(this.data);
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

class ForeignPiGetSlicPOListError extends ForeignPoState {
  final String error;

  ForeignPiGetSlicPOListError(this.error);
}

final class ForeignPoGetItemCodeByItemSKUError extends ForeignPoState {
  final String error;

  ForeignPoGetItemCodeByItemSKUError(this.error);
}
