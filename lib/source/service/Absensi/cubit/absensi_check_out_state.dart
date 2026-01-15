part of 'absensi_check_out_cubit.dart';

@immutable
sealed class AbsensiCheckOutState {}

final class AbsensiCheckOutInitial extends AbsensiCheckOutState {}

final class AbsensiCheckOutLoading extends AbsensiCheckOutState {}

final class AbsensiCheckOutLoaded extends AbsensiCheckOutState {
  final int? statusCode;
  final dynamic json;

  AbsensiCheckOutLoaded({required this.statusCode, required this.json});
}

final class AbsensiCheckOutFailed extends AbsensiCheckOutState {
  final int? statusCode;
  final dynamic json;

  AbsensiCheckOutFailed({required this.statusCode, required this.json});
}
