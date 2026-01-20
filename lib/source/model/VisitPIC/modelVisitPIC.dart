import 'dart:convert';

List<ModelVisitPic> modelVisitPicfromJson(String str) => List<ModelVisitPic>.from(jsonDecode(str).map((x) => ModelVisitPic.fromJson(x)));

class ModelVisitPic {

  final String? visitationdVisitationOid;
  final String? visitationdOid;
  final String? visitationdRemarks;
  final String? visitationdJabatan;
  ModelVisitPic({required this.visitationdVisitationOid, required this.visitationdOid, required this.visitationdRemarks, required this.visitationdJabatan});

  factory ModelVisitPic.fromJson(Map<String, dynamic> json) {
    return ModelVisitPic(
      visitationdVisitationOid: json["visitationd_visitation_oid"],
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
      visitationdJabatan: json["visitationd_jabatan"],
    );
  }
}
