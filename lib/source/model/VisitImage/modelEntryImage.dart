import 'dart:io';

import 'package:camera/camera.dart';

class ModelEntryImage {
  final String? visitationdVisitationOid;
  final String? visitationdOid;
  final String? visitationdRemarks;
  final dynamic? visitationdImages;

  ModelEntryImage({required this.visitationdVisitationOid, required this.visitationdOid, required this.visitationdRemarks, this.visitationdImages});
  bool get hasLocalImage => visitationdImages != null;
  factory ModelEntryImage.fromJson(Map<String, dynamic> json) {
    return ModelEntryImage(
      visitationdImages: json["visitationd_image"],
      visitationdVisitationOid: json["visitationd_visitation_oid"],
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
    );
  }
  Map<String, dynamic> toJson() => {
    "visitationd_visitation_oid": visitationdVisitationOid,
    "visitationd_oid": visitationdOid,
    "visitationd_remarks": visitationdRemarks,
    "visitationd_image": visitationdImages,
  };
  ModelEntryImage copyWith({String? visitationdVisitationOid, String? visitationdOid, String? visitationdRemarks, dynamic? visitationdImages}) {
    return ModelEntryImage(
      visitationdVisitationOid: visitationdVisitationOid ?? this.visitationdVisitationOid,
      visitationdOid: visitationdOid ?? this.visitationdOid,
      visitationdRemarks: visitationdRemarks ?? this.visitationdRemarks,
      visitationdImages: visitationdImages ?? this.visitationdImages,
    );
  }

  @override
  String toString() =>
      "{visitationdOid: $visitationdOid, visitationdRemarks: $visitationdRemarks, visitationdVisitationOid: $visitationdVisitationOid, visitationdImages: ${visitationdImages}}";
}
