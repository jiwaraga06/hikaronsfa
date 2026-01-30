part of 'insert_visitation_image_cubit.dart';

@immutable
sealed class InsertVisitationImageState {}

final class InsertVisitationImageInitial extends InsertVisitationImageState {}

final class InsertVisitationImageLoading extends InsertVisitationImageState {}

final class InsertVisitationImageLoaded extends InsertVisitationImageState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationImageLoaded({required this.statusCode, required this.json});
}

final class InsertVisitationImageFailed extends InsertVisitationImageState {
  final int? statusCode;
  final dynamic json;

  InsertVisitationImageFailed({required this.statusCode, required this.json});
}
