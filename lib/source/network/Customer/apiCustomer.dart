import 'package:hikaronsfa/source/env/env.dart';

class ApiCustomer {
  static getCustomerAll(salesId) {
    return "$url/api/customer/getAllCustomer/$salesId";
  }
}
