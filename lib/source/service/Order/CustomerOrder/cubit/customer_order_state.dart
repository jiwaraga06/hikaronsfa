part of 'customer_order_cubit.dart';

@immutable
sealed class CustomerOrderState {}

final class CustomerOrderInitial extends CustomerOrderState {}

final class CustomerOrderLoading extends CustomerOrderState {}

final class CustomerOrderLoaded extends CustomerOrderState {
  final int statusCode;
  final String message;
  final List<ModelCustomerOrder> model;

  CustomerOrderLoaded({required this.statusCode, required this.message, required this.model});
}

final class CustomerOrderFailed extends CustomerOrderState {
  final int statusCode;
  final String message;

  CustomerOrderFailed({required this.statusCode, required this.message});
}
