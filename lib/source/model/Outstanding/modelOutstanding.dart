import 'dart:convert';

List<ModelOutstandingShipment> modelOutstandingShipmentfromJson(String str) =>
    List<ModelOutstandingShipment>.from(jsonDecode(str).map((x) => ModelOutstandingShipment.fromJson(x)));

class ModelOutstandingShipment {
  final String? customer;
  final String? design;
  final String? color;
  final String? qtyRolSo;
  final String? qtyRolOpenShipment;
  final String? date;
  ModelOutstandingShipment({required this.customer, required this.design, required this.color, required this.qtyRolSo, required this.qtyRolOpenShipment, this.date});

  factory ModelOutstandingShipment.fromJson(Map<String, dynamic> json) {
    return ModelOutstandingShipment(
      customer: json["customer"],
      design: json["design"],
      color: json["color"],
      qtyRolSo: json["qty_rol_so"],
      qtyRolOpenShipment: json["qty_rol_open_shipment"],
      date: json["date"],
    );
  }
}
