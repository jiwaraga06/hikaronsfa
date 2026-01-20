import 'package:hikaronsfa/source/network/VisitPic/apiVisitPic.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryVisitPic {
  Future getVisitPic(oid, context) async {
    var json = await network(url: ApiVisitPic.getPic(oid), method: "GET", body: null, context: context);
    return json;
  }

  Future addVisitPic(body, context) async {
    var json = await network(url: ApiVisitPic.addPic(), method: "POST", body: body, context: context);
    return json;
  }

  Future editVisitPic(body, context) async {
    var json = await network(url: ApiVisitPic.editPic(), method: "POST", body: body, context: context);
    return json;
  }
}
