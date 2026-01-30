import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hikaronsfa/source/env/address.dart';
// import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';

part 'marker_location_state.dart';

class MarkerLocationCubit extends Cubit<MarkerLocationState> {
  MarkerLocationCubit() : super(MarkerLocationInitial());
  // Location location = Location();
  // bool? serviceEnabled;
  // PermissionStatus? permissionGranted;
  // LocationData? locationData;
  bool? serviceEnabled;
  LocationPermission? permission;

  void reset(){
    emit(MarkerLocationInitial());
  }

  void getCurrentLocation() async {
    // bool isJailBroken = await SafeDevice.isJailBroken;
    // bool isRealDevice = await SafeDevice.isRealDevice;
    // bool isMockLocation = await SafeDevice.isMockLocation;
    // bool isSafeDevice = await SafeDevice.isSafeDevice;
    // print("jailbrokder: $isJailBroken");
    // print("realDevice: $isRealDevice");
    // print("mockLocation: $isMockLocation");
    // print("safeDevice: $isSafeDevice");
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    emit(MarkerLocationLoading());

    await Geolocator.getCurrentPosition().then((location) async {
      print("isMock : ${location.isMocked}");
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      var alamat = await getFullAddress(latitude: location.latitude, longitude: location.longitude);
      // print(placemarks[0]);
      if (location.isMocked == true) {
        emit(MarkerLocationFailed(isMock: true, message: "Maaf, fake gps terdeteksi"));
      } else {
        emit(MarkerLocationLoaded(latitude: location.latitude, longitude: location.longitude, myPlacement: placemarks, alamatSaya: alamat));
      }
    });
    // serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled!) {
    //   serviceEnabled = await location.requestService();
    //   if (!serviceEnabled!) {
    //     return;
    //   }
    // }

    // permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    // await location.getLocation().then((data) {
    //   print(data.isMock);
    //   print(data);
    //   emit(MarkerLocationLoaded(latitude: data.latitude, longitude: data.longitude));
    // });
  }

  void getAddressCustomer(num latitude, num longitude) {}
}
