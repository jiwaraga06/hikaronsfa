part of 'insertorder_cubit.dart';

@immutable
sealed class InsertorderState {}

final class InsertorderInitial extends InsertorderState {}

final class InsertorderLoading extends InsertorderState {}

final class InsertorderLoaded extends InsertorderState {
  final int statusCode;
  final String message;
  final dynamic json;

  InsertorderLoaded({required this.statusCode, required this.message, required this.json});
}

final class InsertorderFailed extends InsertorderState {
  final int statusCode;
  final String message;
  final dynamic json;

  InsertorderFailed({required this.statusCode, required this.message, this.json});
}
