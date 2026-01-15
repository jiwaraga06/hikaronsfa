part of 'absensi_check_in_cubit.dart';

@immutable
sealed class AbsensiCheckInState {}

final class AbsensiCheckInInitial extends AbsensiCheckInState {}

final class AbsensiCheckInLoading extends AbsensiCheckInState {}

final class AbsensiCheckInLoaded extends AbsensiCheckInState {
  final int? statusCode;
  final dynamic json;

  AbsensiCheckInLoaded({required this.statusCode, required this.json});
}

final class AbsensiCheckInFailed extends AbsensiCheckInState {
  final int? statusCode;
  final dynamic json;

  AbsensiCheckInFailed({required this.statusCode, required this.json});
}
