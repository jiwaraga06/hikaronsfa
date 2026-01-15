part of 'distance_location_cubit.dart';

@immutable
sealed class DistanceLocationState {}

final class DistanceLocationInitial extends DistanceLocationState {}

final class DistanceLocationLoading extends DistanceLocationState {}

final class DistanceLocationLoaded extends DistanceLocationState {
  final num? distance;

  DistanceLocationLoaded({required this.distance});
}
