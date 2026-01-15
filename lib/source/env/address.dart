import 'package:geocoding/geocoding.dart';

Future<String> getFullAddress({required double latitude, required double longitude}) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      return [
        // place.street,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e!.isNotEmpty).join(', ');
    }
    return '-';
  } catch (e) {
    return 'Alamat tidak ditemukan';
  }
}
