import 'package:hikaronsfa/source/env/env.dart';

class ApiLocation {
  static addLocation() {
    return "$url/api/location/addLocation";
  }
  static getLocationCustomer(customerId) {
    return "$url/api/location/getLocationCustomer/$customerId";
  }
}
