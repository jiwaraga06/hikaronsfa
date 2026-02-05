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

  static getCustomerOrder(salesid) {
    return "$url/api/orders/getCustomerOrder/$salesid";
  }

  static meterPerRoll(ptcId) {
    return "$url/api/orders/meterPerRoll/$ptcId";
  }

  static insertOrder() {
    return "$url/api/orders/insertOrder";
  }

  static updateOrder() {
    return "$url/api/orders/updateOrder";
  }

  static deleteOrder() {
    return "$url/api/orders/deleteOrder";
  }
}
