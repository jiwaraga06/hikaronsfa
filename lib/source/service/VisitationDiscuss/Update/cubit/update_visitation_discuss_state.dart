part of 'update_visitation_discuss_cubit.dart';

@immutable
sealed class UpdateVisitationDiscussState {}

final class UpdateVisitationDiscussInitial extends UpdateVisitationDiscussState {}

final class UpdateVisitationDiscussLoading extends UpdateVisitationDiscussState {}

final class UpdateVisitationDiscussFailed extends UpdateVisitationDiscussState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationDiscussFailed({required this.statusCode, required this.json});
}

final class UpdateVisitationDiscussLoaded extends UpdateVisitationDiscussState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationDiscussLoaded({required this.statusCode, required this.json});
}
