import 'dart:convert';

List<ModelColor> modelColorfromJson(String str) => List<ModelColor>.from(jsonDecode(str).map((x) => ModelColor.fromJson(x)));

class ModelColor {
  final int? ptId;
  final String? ptName;
  final String? colorCode;
  final int? ptPtcId;
  final String? ptcName;
  ModelColor({required this.ptId, required this.ptName, required this.colorCode, required this.ptPtcId, required this.ptcName});

  factory ModelColor.fromJson(Map<String, dynamic> json) {
    return ModelColor(ptId: json["pt_id"], ptName: json['pt_name'], colorCode: json["color_code"], ptPtcId: json['pt_ptc_id'], ptcName: json['ptc_name']);
  }
}
