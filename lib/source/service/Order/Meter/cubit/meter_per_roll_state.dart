part of 'meter_per_roll_cubit.dart';

@immutable
sealed class MeterPerRollState {}

final class MeterPerRollInitial extends MeterPerRollState {}

final class MeterPerRollLoading extends MeterPerRollState {}

final class MeterPerRollLoaded extends MeterPerRollState {
  final int statusCode;
  final String message;
  final dynamic json;

  MeterPerRollLoaded({required this.statusCode, required this.message, required this.json});
}

final class MeterPerRollFailed extends MeterPerRollState {
  final int statusCode;
  final String message;

  MeterPerRollFailed({required this.statusCode, required this.message});

}
