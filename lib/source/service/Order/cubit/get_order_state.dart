part of 'get_order_cubit.dart';

@immutable
sealed class GetOrderState {}

final class GetOrderInitial extends GetOrderState {}

final class GetOrderLoading extends GetOrderState {}

final class GetOrderLoaded extends GetOrderState {
  final int? statusCode;
  final List<ModelOrder>? modelOrder;

  GetOrderLoaded({required this.statusCode, required this.modelOrder});
}

final class GetOrderFailed extends GetOrderState {
  final int? statusCode;
  final dynamic json;

  GetOrderFailed({required this.statusCode, required this.json});
}
