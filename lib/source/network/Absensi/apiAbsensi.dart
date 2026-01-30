import 'package:hikaronsfa/source/env/env.dart';

class ApiAbseni {
  static checkIN() {
    return "$url/api/absensi/checkIN";
  }

  static checkOUT() {
    return "$url/api/absensi/checkOUT";
  }

  static lastCheckIn(salesid) {
    return "$url/api/absensi/lastcheckIN/$salesid";
  }

  static radius() {
    return "$url/api/radius/getRadius";
  }
}
