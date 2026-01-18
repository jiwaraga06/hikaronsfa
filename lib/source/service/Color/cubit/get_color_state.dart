part of 'get_color_cubit.dart';

@immutable
sealed class GetColorState {}

final class GetColorInitial extends GetColorState {}

final class GetColorLoading extends GetColorState {}

final class GetColorLoaded extends GetColorState {
  final int? statusCode;
  final List<ModelColor>? modelColor;

  GetColorLoaded({required this.statusCode, required this.modelColor});
}

final class GetColorFailed extends GetColorState {
  final int? statusCode;
  final dynamic json;

  GetColorFailed({required this.statusCode, required this.json});
}
