import 'package:hikaronsfa/source/env/env.dart';

class ApiOrder {
  static getOrder(salesId, startdate, enddate) {
    return "$url/api/orders/getOrder/$salesId/$startdate/$enddate";
  }

  static getOrderDetail(oid, salesId) {
    return "$url/api/orders/getOrderDetail/$oid/$salesId";
  }

  static getDesign() {
    return "$url/api/orders/getDesign";
  }

  static getColorbyDesign(designId) {
    return "$url/api/orders/getColorbyDesign/$designId";
  }
}
