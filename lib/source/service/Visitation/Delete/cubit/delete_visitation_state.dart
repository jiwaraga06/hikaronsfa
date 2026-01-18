part of 'delete_visitation_cubit.dart';

@immutable
sealed class DeleteVisitationState {}

final class DeleteVisitationInitial extends DeleteVisitationState {}

final class DeleteVisitationLoading extends DeleteVisitationState {}

final class DeleteVisitationLoaded extends DeleteVisitationState {
  final int? statusCode;
  final dynamic json;

  DeleteVisitationLoaded({required this.statusCode, required this.json});
}

final class DeleteVisitationFailed extends DeleteVisitationState {
  final int? statusCode;
  final dynamic json;

  DeleteVisitationFailed({required this.statusCode, required this.json});
}
