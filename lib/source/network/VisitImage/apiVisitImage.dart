import 'package:hikaronsfa/source/env/env.dart';

class ApiVisitImage {
  static getImage(oid) {
    return "$url/api/Image/getImage/$oid";
  }

  static addImage() {
    return "$url/api/Image/addImage";
  }

  static editImage() {
    return "$url/api/Image/editImage";
  }
}
