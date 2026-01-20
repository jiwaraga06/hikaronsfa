part of 'insert_visitation_discuss_cubit.dart';

@immutable
sealed class InsertVisitationDiscussState {}

final class InsertVisitationDiscussInitial extends InsertVisitationDiscussState {}

final class InsertVisitationDiscussLoading extends InsertVisitationDiscussState {}

final class InsertVisitationDiscussLoaded extends InsertVisitationDiscussState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationDiscussLoaded({required this.statusCode, required this.json});
}

final class InsertVisitationDiscussFailed extends InsertVisitationDiscussState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationDiscussFailed({required this.statusCode, required this.json});
}
