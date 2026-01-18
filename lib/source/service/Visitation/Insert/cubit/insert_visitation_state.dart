part of 'insert_visitation_cubit.dart';

@immutable
sealed class InsertVisitationState {}

final class InsertVisitationInitial extends InsertVisitationState {}

final class InsertVisitationLoading extends InsertVisitationState {}

final class InsertVisitationLoaded extends InsertVisitationState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationLoaded({required this.statusCode, required this.json});
}

final class InsertVisitationFailed extends InsertVisitationState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationFailed({required this.statusCode, required this.json});
}
