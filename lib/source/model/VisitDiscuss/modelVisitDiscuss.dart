import 'dart:convert';

List<ModelVisitDiscuss> modelVisitDiscussfromJson(String str) => List<ModelVisitDiscuss>.from(jsonDecode(str).map((x) => ModelVisitDiscuss.fromJson(x)));

class ModelVisitDiscuss {
  final String? visitationdVisitationOid;
  final String? visitationdOid;
  final String? visitationdRemarks;
  ModelVisitDiscuss({required this.visitationdVisitationOid, required this.visitationdOid, required this.visitationdRemarks});

  factory ModelVisitDiscuss.fromJson(Map<String, dynamic> json) {
    return ModelVisitDiscuss(
      visitationdVisitationOid: json["visitationd_visitation_oid"],
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
    );
  }
}
