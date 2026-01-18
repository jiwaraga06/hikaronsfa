import 'dart:convert';

List<ModelCustomerVisitation> modelCustomerVisitationfromJson(String str) =>
    List<ModelCustomerVisitation>.from(jsonDecode(str).map((x) => ModelCustomerVisitation.fromJson(x)));

class ModelCustomerVisitation {
  final int? ptnrId;
  final String? ptnrName;
  final String? attndOid;
  final String? attndDateIn;

  ModelCustomerVisitation({required this.ptnrId, required this.ptnrName, required this.attndOid, required this.attndDateIn});
  factory ModelCustomerVisitation.fromJson(Map<String, dynamic> json) {
    return ModelCustomerVisitation(ptnrId: json["ptnr_id"], ptnrName: json["ptnr_name"], attndOid: json['attnd_oid'], attndDateIn: json['attnd_date_in']);
  }
}
