part of 'insert_visitation_pic_cubit.dart';

@immutable
sealed class InsertVisitationPicState {}

final class InsertVisitationPicInitial extends InsertVisitationPicState {}

final class InsertVisitationPicLoading extends InsertVisitationPicState {}

final class InsertVisitationPicLoaded extends InsertVisitationPicState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationPicLoaded({required this.statusCode, required this.json});
}

final class InsertVisitationPicFailed extends InsertVisitationPicState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationPicFailed({required this.statusCode, required this.json});
}
