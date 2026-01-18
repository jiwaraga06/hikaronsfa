import 'package:hikaronsfa/source/env/env.dart';

class ApiCustomer {
  static getCustomerAll(salesId) {
    return "$url/api/customer/getLocationCustomer/$salesId";
  }
  static getCustomerVisitation(salesId) {
    return "$url/api/customer/getCustomerVisitation/$salesId";
  }
}
