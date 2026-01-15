import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'distance_location_state.dart';

class DistanceLocationCubit extends Cubit<DistanceLocationState> {
  DistanceLocationCubit() : super(DistanceLocationInitial());

  void reset() {
    emit(DistanceLocationInitial());
  }

  void getDistance(latitudePlace, longitudePlace) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    num distanceInMeters = Geolocator.distanceBetween(position.latitude, position.longitude, latitudePlace, longitudePlace);
    emit(DistanceLocationLoading());
    // await Future.delayed(Duration(seconds: 1));
    // EasyLoading.showInfo(distanceInMeters.toString());
    emit(DistanceLocationLoaded(distance: distanceInMeters));
  }
}
