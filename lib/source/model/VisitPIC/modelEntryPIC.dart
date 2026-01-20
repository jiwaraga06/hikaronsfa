class ModelEntryPIC {
  final String? visitationdVisitationOid;
  final String? visitationdOid;
  final String? visitationdRemarks;
  final String? visitationdJabatan;
  ModelEntryPIC({required this.visitationdVisitationOid, required this.visitationdOid, required this.visitationdRemarks, required this.visitationdJabatan});
  factory ModelEntryPIC.fromJson(Map<String, dynamic> json) {
    return ModelEntryPIC(
      visitationdVisitationOid: json["visitationd_visitation_oid"],
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
      visitationdJabatan: json["visitationd_jabatan"],
    );
  }
    Map<String, dynamic> toJson() => {
    "visitationd_visitation_oid": visitationdVisitationOid,
    "visitationd_oid": visitationdOid,
    "visitationd_remarks": visitationdRemarks,
    "visitationd_jabatan": visitationdJabatan,
  };
  ModelEntryPIC copyWith({String? visitationdVisitationOid, String? visitationdOid, String? visitationdRemarks, String? visitationdJabatan}) {
    return ModelEntryPIC(
      visitationdVisitationOid: visitationdVisitationOid ?? this.visitationdVisitationOid,
      visitationdOid: visitationdOid ?? this.visitationdOid,
      visitationdRemarks: visitationdRemarks ?? this.visitationdRemarks,
      visitationdJabatan: visitationdJabatan ?? this.visitationdJabatan,
    );
  }

  @override
  String toString() =>
      "{visitationdOid: $visitationdOid, visitationdRemarks: $visitationdRemarks, visitationdJabatan: $visitationdJabatan, visitationdVisitationOid: $visitationdVisitationOid}";

}
