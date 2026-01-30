import 'package:hikaronsfa/source/env/env.dart';

class ApiVisitImage {
  static getImage(oid) {
    return "$url/api/visitImage/getLampiran/$oid";
  }

  static addImage() {
    return "$url/api/visitImage/addLampiran";
  }

  static editImage() {
    return "$url/api/visitImage/editLampiran";
  }
}
