class ModelEntryDiscuss {
  final String? visitationdVisitationOid;
  final String? visitationdOid;
  final String? visitationdRemarks;
  ModelEntryDiscuss({required this.visitationdVisitationOid, required this.visitationdOid, required this.visitationdRemarks});

  factory ModelEntryDiscuss.fromJson(Map<String, dynamic> json) {
    return ModelEntryDiscuss(
      visitationdVisitationOid: json["visitationd_visitation_oid"],
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
    );
  }
  Map<String, dynamic> toJson() => {
    "visitationd_visitation_oid": visitationdVisitationOid,
    "visitationd_oid": visitationdOid,
    "visitationd_remarks": visitationdRemarks,
  };
  ModelEntryDiscuss copyWith({String? visitationdVisitationOid, String? visitationdOid, String? visitationdRemarks}) {
    return ModelEntryDiscuss(
      visitationdVisitationOid: visitationdVisitationOid ?? this.visitationdVisitationOid,
      visitationdOid: visitationdOid ?? this.visitationdOid,
      visitationdRemarks: visitationdRemarks ?? this.visitationdRemarks,
    );
  }

  @override
  String toString() => "{visitationdOid: $visitationdOid, visitationdRemarks: $visitationdRemarks, visitationdVisitationOid: $visitationdVisitationOid}";
}
