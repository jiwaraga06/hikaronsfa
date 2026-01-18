import 'dart:convert';

List<ModelColor> modelColorfromJson(String str) => List<ModelColor>.from(jsonDecode(str).map((x) => ModelColor.fromJson(x)));

class ModelColor {
  final int? ptId;
  final String? colorCode;
  ModelColor({required this.ptId, required this.colorCode});

  factory ModelColor.fromJson(Map<String, dynamic> json) {
    return ModelColor(ptId: json["pt_id"], colorCode: json["color_code"]);
  }
}
