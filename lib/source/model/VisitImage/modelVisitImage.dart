import 'dart:convert';

List<ModelVisitImage> modelVisitImagefromJson(String str) => List<ModelVisitImage>.from(jsonDecode(str).map((x) => ModelVisitImage.fromJson(x)));

class ModelVisitImage {
  final String? visitationdVisitationOid;
  final String? visitationdOid;
  final String? visitationdRemarks;
  final String? visitationdImages;
  ModelVisitImage({required this.visitationdVisitationOid, required this.visitationdOid, required this.visitationdRemarks, required this.visitationdImages});

  factory ModelVisitImage.fromJson(Map<String, dynamic> json) {
    return ModelVisitImage(
      visitationdImages: json["visitationd_image"],
      visitationdVisitationOid: json["visitationd_visitation_oid"],
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
    );
  }
}
