import 'package:hikaronsfa/source/env/env.dart';

class ApiVisitDiscuss {
  static getDiscuss(oid) {
    return "$url/api/discuss/getDiscuss/$oid";
  }

  static addDiscuss() {
    return "$url/api/discuss/addDiscuss";
  }

  static editDiscuss() {
    return "$url/api/discuss/editDiscuss";
  }
}
