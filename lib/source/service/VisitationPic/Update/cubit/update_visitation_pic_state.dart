part of 'update_visitation_pic_cubit.dart';

@immutable
sealed class UpdateVisitationPicState {}

final class UpdateVisitationPicInitial extends UpdateVisitationPicState {}

final class UpdateVisitationPicLoading extends UpdateVisitationPicState {}

final class UpdateVisitationPicLoaded extends UpdateVisitationPicState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationPicLoaded({required this.statusCode, required this.json});
}

final class UpdateVisitationPicFailed extends UpdateVisitationPicState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationPicFailed({required this.statusCode, required this.json});
}
