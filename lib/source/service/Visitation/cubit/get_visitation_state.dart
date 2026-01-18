part of 'get_visitation_cubit.dart';

@immutable
sealed class GetVisitationState {}

final class GetVisitationInitial extends GetVisitationState {}

final class GetVisitationLoading extends GetVisitationState {}

final class GetVisitationLoaded extends GetVisitationState {
  final int? statusCode;
  final List<ModelVisitation>? modelVisitation;

  GetVisitationLoaded({required this.statusCode, required this.modelVisitation});
}

final class GetVisitationFailed extends GetVisitationState {
  final int? statusCode;
  final dynamic json;

  GetVisitationFailed({required this.statusCode, required this.json});
}
