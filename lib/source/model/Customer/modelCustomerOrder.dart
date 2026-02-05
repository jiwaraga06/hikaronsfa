import 'dart:convert';

List<ModelCustomerOrder> modelCustomerOrderfromJson(String str) => List<ModelCustomerOrder>.from(jsonDecode(str).map((x) => ModelCustomerOrder.fromJson(x)));

class ModelCustomerOrder {
  final int? ptnrId;
  final String? ptnrName;
  ModelCustomerOrder({required this.ptnrId, required this.ptnrName});

  factory ModelCustomerOrder.fromJson(Map<String, dynamic> json) {
    return ModelCustomerOrder(ptnrId: json["ptnr_id"], ptnrName: json["ptnr_name"]);
  }
}
