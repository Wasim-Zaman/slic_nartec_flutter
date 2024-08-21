part of 'goods_issue_cubit.dart';

abstract class GoodsIssueState {}

class GoodsIssueInitia extends GoodsIssueState {}

final class GoodsIssueDateChanged extends GoodsIssueState {}

// ? Loading

final class GoodsIssuePostLoading extends GoodsIssueState {}

final class GoodsIssueTransactionCodesLoading extends GoodsIssueState {}

// * Success

final class GoodsIssuePostSuccess extends GoodsIssueState {
  final String message;
  GoodsIssuePostSuccess({required this.message});
}

final class GoodsIssueTransactionCodesSuccess extends GoodsIssueState {}

// ! Error

final class GoodsIssuePostError extends GoodsIssueState {
  final String errorMessage;
  GoodsIssuePostError({required this.errorMessage});
}

final class GoodsIssueTransactionCodesError extends GoodsIssueState {
  final String errorMessage;
  GoodsIssueTransactionCodesError({required this.errorMessage});
}
