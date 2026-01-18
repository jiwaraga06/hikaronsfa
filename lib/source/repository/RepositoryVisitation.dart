import 'package:hikaronsfa/source/network/Visitation/apiVisitation.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryVisitation {
  Future getVisitation(salesId, startdate, enddate, context) async {
    var json = await network(url: ApiVisitation.getVisitation(salesId, startdate, enddate), method: "GET", body: null, context: context);
    return json;
  }

  Future getVisitationDetail(salesId, oid, context) async {
    var json = await network(url: ApiVisitation.getVisitationDetail(salesId, oid), method: "GET", body: null, context: context);
    return json;
  }

  Future insertVisitation(body, context) async {
    var json = await network(url: ApiVisitation.insertVisitation(), method: "POST", body: body, context: context);
    return json;
  }

  Future updateVisitation(body, context) async {
    var json = await network(url: ApiVisitation.updateVisitation(), method: "POST", body: body, context: context);
    return json;
  }

  Future deleteVisitation(body, context) async {
    var json = await network(url: ApiVisitation.deleteVisitation(), method: "POST", body: body, context: context);
    return json;
  }
}
