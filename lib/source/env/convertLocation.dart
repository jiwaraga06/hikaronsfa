import 'package:latlong2/latlong.dart';

LatLng getLatLng(String latLng) {
  final parts = latLng.split(',');
  return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
}
