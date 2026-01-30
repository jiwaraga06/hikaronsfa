part of 'marker_location_cubit.dart';

@immutable
sealed class MarkerLocationState {}

final class MarkerLocationInitial extends MarkerLocationState {}

final class MarkerLocationLoading extends MarkerLocationState {}

final class MarkerLocationFailed extends MarkerLocationState {
  bool? isMock = false;
  final String message;

  MarkerLocationFailed({this.isMock, required this.message});
}

final class MarkerLocationLoaded extends MarkerLocationState {
  final double? latitude;
  final double? longitude;
  final List<Placemark>? myPlacement;
  String? alamatSaya;

  MarkerLocationLoaded({required this.latitude, required this.longitude, this.myPlacement, this.alamatSaya});
}
