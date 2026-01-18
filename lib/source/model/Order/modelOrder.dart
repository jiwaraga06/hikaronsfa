import 'dart:convert';

List<ModelOrder> modelOrderfromJson(String str) => List<ModelOrder>.from(jsonDecode(str).map((x) => ModelOrder.fromJson(x)));


class ModelOrder {
  final String? orderOid;
  final String? orderCode;
  final String? orderStatus;
  final String? orderDate;
  final String? ptnrName;
  ModelOrder({required this.orderOid, required this.orderCode, required this.orderStatus, required this.orderDate, required this.ptnrName});

  factory ModelOrder.fromJson(Map<String, dynamic> json) {
    return ModelOrder(
      orderOid: json["order_oid"],
      orderCode: json["order_code"],
      orderStatus: json["order_status"],
      orderDate: json["order_date"],
      ptnrName: json["ptnr_name"],
    );
  }
}
