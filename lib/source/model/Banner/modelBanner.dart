import 'dart:convert';

List<ModelBanner> modelBannerfromJson(String str) => List<ModelBanner>.from(jsonDecode(str).map((x) => ModelBanner.fromJson(x)));

class ModelBanner {
  final int bannerId;
  final String bannerTitle;
  final String bannerDescription;
  final String bannerImage;
  ModelBanner({required this.bannerId, required this.bannerTitle, required this.bannerDescription, required this.bannerImage});

  factory ModelBanner.fromJson(Map<String, dynamic> json) {
    return ModelBanner(
      bannerId: json["banner_id"],
      bannerTitle: json["banner_title"],
      bannerDescription: json["banner_description"],
      bannerImage: json["banner_image"],
    );
  }
}
