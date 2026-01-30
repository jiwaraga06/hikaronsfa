part of 'update_visitation_image_cubit.dart';

@immutable
sealed class UpdateVisitationImageState {}

final class UpdateVisitationImageInitial extends UpdateVisitationImageState {}

final class UpdateVisitationImageLoading extends UpdateVisitationImageState {}

final class UpdateVisitationImageLoaded extends UpdateVisitationImageState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationImageLoaded({required this.statusCode, required this.json});
}

final class UpdateVisitationImageFailed extends UpdateVisitationImageState {
  final int? statusCode;
  final dynamic json;

  UpdateVisitationImageFailed({required this.statusCode, required this.json});
}
