part of 'deleteorder_cubit.dart';

@immutable
sealed class DeleteorderState {}

final class DeleteorderInitial extends DeleteorderState {}

final class DeleteorderLoading extends DeleteorderState {}

final class DeleteorderFailed extends DeleteorderState {
  final int statusCode;
  final String message;

  DeleteorderFailed({required this.statusCode, required this.message});
}

final class DeleteorderLoaded extends DeleteorderState {
  final int statusCode;
  final String message;

  DeleteorderLoaded({required this.statusCode, required this.message});
}
