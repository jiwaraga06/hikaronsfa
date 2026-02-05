part of 'get_order_detail_cubit.dart';

@immutable
sealed class GetOrderDetailState {}

final class GetOrderDetailInitial extends GetOrderDetailState {}

final class GetOrderDetailLoading extends GetOrderDetailState {}

final class GetOrderDetailLoaded extends GetOrderDetailState {
  final int? statusCode;
  final ModelOrderDetail? modelOrderDetail;

  GetOrderDetailLoaded({required this.statusCode, required this.modelOrderDetail});
}

final class GetOrderDetailFailed extends GetOrderDetailState {
  final int? statusCode;
  final String message;
  final dynamic json;

  GetOrderDetailFailed({required this.statusCode, required this.json,required this.message});
}
