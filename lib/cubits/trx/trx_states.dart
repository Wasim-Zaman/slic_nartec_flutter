part of 'trx_cubit.dart';

abstract class TrxState {}

final class TrxInitial extends TrxState {}

// Add other states here

final class TrxByLocationCodeLoading extends TrxState {}

final class TrxByLocationCodeLoaded extends TrxState {}

final class TrxByLocationCodeError extends TrxState {
  final String errorMessage;

  TrxByLocationCodeError({required this.errorMessage});
}
