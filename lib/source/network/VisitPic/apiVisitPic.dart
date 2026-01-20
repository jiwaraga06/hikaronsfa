import 'package:hikaronsfa/source/env/env.dart';

class ApiVisitPic {
  static getPic(oid) {
    return "$url/api/pic/getPIC/$oid";
  }
  static addPic() {
    return "$url/api/pic/addPIC";
  }
  static editPic() {
    return "$url/api/pic/editPIC";
  }
}
