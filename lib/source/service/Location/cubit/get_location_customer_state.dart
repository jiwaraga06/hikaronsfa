part of 'get_location_customer_cubit.dart';

@immutable
sealed class GetLocationCustomerState {}

final class GetLocationCustomerInitial extends GetLocationCustomerState {}

final class GetLocationCustomerLoading extends GetLocationCustomerState {}

final class GetLocationCustomerLoaded extends GetLocationCustomerState {
  final int? statusCode;
  final dynamic json;
  double? latitudePlace;
  double? longitudePlace;

  GetLocationCustomerLoaded({required this.statusCode, required this.json, this.latitudePlace, this.longitudePlace});
}

final class GetLocationCustomerFailed extends GetLocationCustomerState {
  final int? statusCode;
  final dynamic json;

  GetLocationCustomerFailed({required this.statusCode, required this.json});
}
