import 'package:hikaronsfa/source/network/VisitDiscuss/apiVisitDiscuss.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryVisitDiscuss {
  Future getVisitDiscuss(oid, context) async {
    var json = await network(url: ApiVisitDiscuss.getDiscuss(oid), method: "GET", body: null, context: context);
    return json;
  }

  Future addVisitDiscuss(body, context) async {
    var json = await network(url: ApiVisitDiscuss.addDiscuss(), method: "POST", body: body, context: context);
    return json;
  }

  Future editVisitDiscuss(body, context) async {
    var json = await network(url: ApiVisitDiscuss.editDiscuss(), method: "POST", body: body, context: context);
    return json;
  }
}
