import 'package:hikaronsfa/source/env/env.dart';

class ApiVisitation {
  static getVisitation(salesId, startdate, enddate) {
    return "$url/api/visitation/getVisitation/$salesId/$startdate/$enddate";
  }

  static getVisitationDetail(salesId, oid) {
    return "$url/api/visitation/getVisitationDetail/$salesId/$oid";
  }

  static insertVisitation() {
    return "$url/api/visitation/addVisitation";
  }
  static updateVisitation() {
    return "$url/api/visitation/editVisitation";
  }
  static deleteVisitation() {
    return "$url/api/visitation/deleteVisitation";
  }
}
