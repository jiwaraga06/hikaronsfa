part of 'banner_cubit.dart';

@immutable
sealed class BannerState {}

final class BannerInitial extends BannerState {}

final class BannerLoading extends BannerState {}

final class BannerFailed extends BannerState {
  final int statusCode;
  final String message;

  BannerFailed({required this.statusCode, required this.message});
}

final class BannerLoaded extends BannerState {
  final int statusCode;
  final String message;
  final List<ModelBanner> model;

  BannerLoaded({required this.statusCode, required this.message, required this.model});
}
