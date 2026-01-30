part of 'check_permission_cubit.dart';

@immutable
sealed class CheckPermissionState {}

final class CheckPermissionInitial extends CheckPermissionState {}

final class CheckPermissionGranted extends CheckPermissionState {}

final class CheckPermissionDenied extends CheckPermissionState {
  final String message;

  CheckPermissionDenied({required this.message});
}
