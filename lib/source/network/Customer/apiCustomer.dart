import 'package:hikaronsfa/source/env/env.dart';

class ApiCustomer {
  static getLocationCustomer(salesId) {
    return "$url/api/customer/getLocationCustomer/$salesId";
  }

  static getAllCustomer(salesId) {
    return "$url/api/customer/getAllCustomer/$salesId";
  }

  static getCustomerVisitation(salesId) {
    return "$url/api/customer/getCustomerVisitation/$salesId";
  }
  static getCustomerOutstanding(salesId) {
    return "$url/api/customer/getCustomerOutstanding/$salesId";
  }
}
