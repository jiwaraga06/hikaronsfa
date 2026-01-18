import 'dart:convert';

List<ModelVisitation> modelVisitationfromJson(String str) => List<ModelVisitation>.from(jsonDecode(str).map((x) => ModelVisitation.fromJson(x)));

class ModelVisitation {
  final String? attndOid;
  final String? visitationOid;
  final String? visitationCode;
  final String? visitationStatus;
  final String? visitationDate;
  final String? ptnrName;
  ModelVisitation({
    required this.attndOid,
    required this.visitationOid,
    required this.visitationCode,
    required this.visitationStatus,
    required this.visitationDate,
    required this.ptnrName,
  });

  factory ModelVisitation.fromJson(Map<String, dynamic> json) {
    return ModelVisitation(
      attndOid: json["attnd_oid"],
      visitationOid: json["visitation_oid"],
      visitationCode: json["visitation_code"],
      visitationStatus: json["visitation_status"],
      visitationDate: json["visitation_date"],
      ptnrName: json["ptnr_name"],
    );
  }
}
