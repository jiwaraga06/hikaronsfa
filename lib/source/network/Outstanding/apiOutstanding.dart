import 'package:hikaronsfa/source/env/env.dart';

class ApiOutstanding {
  static getOutstandingShipment(salesid, customerid) {
    return "$url/api/shipment/getOutstandingShipment/$salesid/$customerid";
  }
}
