part of 'get_visitation_detail_cubit.dart';

@immutable
sealed class GetVisitationDetailState {}

final class GetVisitationDetailInitial extends GetVisitationDetailState {}

final class GetVisitationDetailLoading extends GetVisitationDetailState {}

final class GetVisitationDetailFailed extends GetVisitationDetailState {
  final int? statusCode;
  final dynamic json;

  GetVisitationDetailFailed({required this.statusCode, required this.json});
}

final class GetVisitationDetailLoaded extends GetVisitationDetailState {
  final int? statusCode;
  final ModelVisitationDetail? modelVisitationDetail;

  GetVisitationDetailLoaded({required this.statusCode, required this.modelVisitationDetail});
}
