part of 'outstanding_shipment_cubit.dart';

@immutable
sealed class OutstandingShipmentState {}

final class OutstandingShipmentInitial extends OutstandingShipmentState {}

final class OutstandingShipmentLoading extends OutstandingShipmentState {}

final class OutstandingShipmentFailed extends OutstandingShipmentState {
  final int statusCode;
  final String message;

  OutstandingShipmentFailed({required this.statusCode, required this.message});
}

final class OutstandingShipmentLoaded extends OutstandingShipmentState {
  final int statusCode;
  final String message;
  final List<ModelOutstandingShipment> model;

  OutstandingShipmentLoaded({required this.statusCode, required this.message, required this.model});
}
