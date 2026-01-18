import 'dart:convert';

List<ModelDesign> modelDesignfromJson(String str) => List<ModelDesign>.from(jsonDecode(str).map((x) => ModelDesign.fromJson(x)));

class ModelDesign {
  final int? designId;
  final String? designCode;
  final String? designName;
  final String? designDesc;
  final String? designActive;
  final int? designLusiColorId;
  final String? designWidth;
  final int? designDesigngId;
  final String? designPik;
  final String? designDensity;
  final String? designGramasi;
  final String? designCodeOld;
  final String? designSdivisionId;

  ModelDesign({
    required this.designId,
    required this.designCode,
    required this.designName,
    required this.designDesc,
    required this.designActive,
    required this.designLusiColorId,
    required this.designWidth,
    required this.designDesigngId,
    required this.designPik,
    required this.designDensity,
    required this.designGramasi,
    required this.designCodeOld,
    required this.designSdivisionId,
  });
  factory ModelDesign.fromJson(Map<String, dynamic> json) {
    return ModelDesign(
      designId: json["design_id"],
      designCode: json["design_code"],
      designName: json["design_name"],
      designDesc: json["design_desc"],
      designActive: json["design_active"],
      designLusiColorId: json["design_lusi_color_id"],
      designWidth: json["design_width"],
      designDesigngId: json["design_designg_id"],
      designPik: json["design_pik"].toString(),
      designDensity: json["design_density"].toString(),
      designGramasi: json["design_gramasi"].toString(),
      designCodeOld: json["design_code_old"].toString(),
      designSdivisionId: json["design_sdivision_id"].toString(),
    );
  }
}
