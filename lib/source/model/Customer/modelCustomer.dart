import 'dart:convert';

List<ModelCustomer> modelCustomerfromJson(String str) => List<ModelCustomer>.from(jsonDecode(str).map((x) => ModelCustomer.fromJson(x)));

class ModelCustomer {
  final int? ptnrId;
  final String? ptnrName;
  ModelCustomer({required this.ptnrId, required this.ptnrName});

  factory ModelCustomer.fromJson(Map<String, dynamic> json) {
    return ModelCustomer(ptnrId: json["ptnr_id"], ptnrName: json["ptnr_name"]);
  }

}
