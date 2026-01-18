part of 'get_customer_visitation_cubit.dart';

@immutable
sealed class GetCustomerVisitationState {}

final class GetCustomerVisitationInitial extends GetCustomerVisitationState {}

final class GetCustomerVisitationLoading extends GetCustomerVisitationState {}

final class GetCustomerVisitationLoaded extends GetCustomerVisitationState {
  final int? statusCode;
  final List<ModelCustomerVisitation>? model;

  GetCustomerVisitationLoaded({required this.statusCode, required this.model});
}

final class GetCustomerVisitationFailed extends GetCustomerVisitationState {
  final int? statusCode;
  final dynamic json;

  GetCustomerVisitationFailed({required this.statusCode, required this.json});
}
