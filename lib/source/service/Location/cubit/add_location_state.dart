part of 'add_location_cubit.dart';

@immutable
sealed class AddLocationState {}

final class AddLocationInitial extends AddLocationState {}

final class AddLocationLoading extends AddLocationState {}

final class AddLocationLoaded extends AddLocationState {
  final int? statusCode;
  final dynamic json;

  AddLocationLoaded({required this.statusCode, required this.json});
}

final class AddLocationFailed extends AddLocationState {
  final int? statusCode;
  final dynamic json;

  AddLocationFailed({required this.statusCode, required this.json});
}
