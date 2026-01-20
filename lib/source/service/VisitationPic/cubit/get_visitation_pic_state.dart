part of 'get_visitation_pic_cubit.dart';

@immutable
sealed class GetVisitationPicState {}

final class GetVisitationPicInitial extends GetVisitationPicState {}

final class GetVisitationPicLoading extends GetVisitationPicState {}

final class GetVisitationPicLoaded extends GetVisitationPicState {
  final int? statusCode;
  final List<ModelVisitPic>? model;

  GetVisitationPicLoaded({required this.statusCode, required this.model});
}

final class GetVisitationPicFailed extends GetVisitationPicState {
  final int? statusCode;
  final dynamic json;

  GetVisitationPicFailed({required this.statusCode, required this.json});
}
