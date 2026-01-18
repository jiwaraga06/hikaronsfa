part of 'update_visitation_cubit.dart';

@immutable
sealed class UpdateVisitationState {}

final class UpdateVisitationInitial extends UpdateVisitationState {}

final class UpdateVisitationLoading extends UpdateVisitationState {}

final class UpdateVisitationLoaded extends UpdateVisitationState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationLoaded({required this.statusCode, required this.json});
}

final class UpdateVisitationFailed extends UpdateVisitationState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationFailed({required this.statusCode, required this.json});
}
