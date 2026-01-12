part of 'marker_location_cubit.dart';

@immutable
sealed class MarkerLocationState {}

final class MarkerLocationInitial extends MarkerLocationState {}

final class MarkerLocationLoading extends MarkerLocationState {}

final class MarkerLocationFailed extends MarkerLocationState {
  final bool isMock;
  final String message;

  MarkerLocationFailed({required this.isMock, required this.message});
}

final class MarkerLocationLoaded extends MarkerLocationState {
  final double? latitude;
  final double? longitude;
  final List<Placemark>? myPlacement;

  MarkerLocationLoaded({required this.latitude, required this.longitude, this.myPlacement});
}
