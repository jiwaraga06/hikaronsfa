part of 'updateorder_cubit.dart';

@immutable
sealed class UpdateorderState {}

final class UpdateorderInitial extends UpdateorderState {}

final class UpdateorderLoading extends UpdateorderState {}

final class UpdateorderLoaded extends UpdateorderState {
  final int statusCode;
  final String message;
  final dynamic json;

  UpdateorderLoaded({required this.statusCode, required this.message, required this.json});
}

final class UpdateorderFailed extends UpdateorderState {
  final int statusCode;
  final String message;

  UpdateorderFailed({required this.statusCode, required this.message});
}
