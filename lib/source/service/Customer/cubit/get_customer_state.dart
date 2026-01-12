part of 'get_customer_cubit.dart';

@immutable
sealed class GetCustomerState {}

final class GetCustomerInitial extends GetCustomerState {}

final class GetCustomerLoading extends GetCustomerState {}

final class GetCustomerLoaded extends GetCustomerState {
  final int? statusCode;
  final List<ModelCustomer> model;

  GetCustomerLoaded({required this.statusCode, required this.model});
}

final class GetCustomerFailed extends GetCustomerState {
  final int? statusCode;
  final dynamic json;

  GetCustomerFailed({required this.statusCode, required this.json});
}
