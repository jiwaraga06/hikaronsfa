part of 'approve_order_cubit.dart';

@immutable
sealed class ApproveOrderState {}

final class ApproveOrderInitial extends ApproveOrderState {}

final class ApproveOrderLoading extends ApproveOrderState {}

final class ApproveOrderLoaded extends ApproveOrderState {
  final int statusCode;
  final String message;

  ApproveOrderLoaded({required this.statusCode, required this.message});
}

final class ApproveOrderFailed extends ApproveOrderState {
  final int statusCode;
  final String message;

  ApproveOrderFailed({required this.statusCode, required this.message});
}
