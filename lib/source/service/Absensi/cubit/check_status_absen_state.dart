part of 'check_status_absen_cubit.dart';

@immutable
sealed class CheckStatusAbsenState {}

final class CheckStatusAbsenInitial extends CheckStatusAbsenState {}

final class CheckStatusAbsenLoaded extends CheckStatusAbsenState {
  final bool? isReadyCheckin;

  CheckStatusAbsenLoaded({required this.isReadyCheckin});
}
