part of 'get_last_check_in_cubit.dart';

@immutable
sealed class GetLastCheckInState {}

final class GetLastCheckInInitial extends GetLastCheckInState {}

final class GetLastCheckInLoading extends GetLastCheckInState {}

final class GetLastCheckInFailed extends GetLastCheckInState {
  final int? statusCode;
  final dynamic json;

  GetLastCheckInFailed({required this.statusCode, required this.json});
}

final class GetLastCheckInLoaded extends GetLastCheckInState {
  final int? statusCode;
  final ModelLastCheckIn? model;

  GetLastCheckInLoaded({required this.statusCode, required this.model});
}
